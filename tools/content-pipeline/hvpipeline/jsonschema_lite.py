"""Küçük JSON Schema (draft 2020-12 alt kümesi) doğrulayıcısı; yalnızca standart kütüphane.

Desteklenen anahtarlar: type, enum, const, properties, required, additionalProperties,
items, minItems, maxItems, uniqueItems, minLength, pattern, minimum, maximum,
exclusiveMinimum, $ref (yerel #/$defs/...), allOf, anyOf, oneOf, if/then/else.
Testlerde `jsonschema` paketi kuruluysa sonuçlar onunla karşılaştırılır.
"""

from __future__ import annotations

import re
from typing import Any

TYPES = {
    "object": dict, "array": list, "string": str, "boolean": bool, "null": type(None),
}


def _is_type(v: Any, t: str) -> bool:
    if t == "integer":
        return isinstance(v, int) and not isinstance(v, bool)
    if t == "number":
        return isinstance(v, (int, float)) and not isinstance(v, bool)
    return isinstance(v, TYPES[t])


class Validator:
    def __init__(self, schema: dict):
        self.root = schema

    def _resolve(self, ref: str) -> dict:
        if not ref.startswith("#/"):
            raise ValueError(f"desteklenmeyen $ref: {ref}")
        node: Any = self.root
        for part in ref[2:].split("/"):
            node = node[part]
        return node

    def errors(self, instance: Any) -> list[str]:
        out: list[str] = []
        self._v(instance, self.root, "$", out)
        return out

    def _v(self, x: Any, s: Any, path: str, out: list[str]) -> None:
        if s is True or s == {}:
            return
        if s is False:
            out.append(f"{path}: izin verilmeyen değer")
            return
        if "$ref" in s:
            self._v(x, self._resolve(s["$ref"]), path, out)
        t = s.get("type")
        if t is not None:
            ts = t if isinstance(t, list) else [t]
            if not any(_is_type(x, tt) for tt in ts):
                out.append(f"{path}: tür {'/'.join(ts)} olmalı")
                return
        if "const" in s and x != s["const"]:
            out.append(f"{path}: değer {s['const']!r} olmalı")
        if "enum" in s and x not in s["enum"]:
            out.append(f"{path}: değer {s['enum']} içinden olmalı (bulunan {x!r})")
        if isinstance(x, str):
            if "minLength" in s and len(x) < s["minLength"]:
                out.append(f"{path}: en az {s['minLength']} karakter olmalı")
            if "pattern" in s and not re.search(s["pattern"], x):
                out.append(f"{path}: {x!r} kalıba uymuyor ({s['pattern']})")
        if _is_type(x, "number"):
            if "minimum" in s and x < s["minimum"]:
                out.append(f"{path}: en az {s['minimum']} olmalı")
            if "maximum" in s and x > s["maximum"]:
                out.append(f"{path}: en çok {s['maximum']} olmalı")
            if "exclusiveMinimum" in s and x <= s["exclusiveMinimum"]:
                out.append(f"{path}: {s['exclusiveMinimum']} değerinden büyük olmalı")
        if isinstance(x, list):
            if "minItems" in s and len(x) < s["minItems"]:
                out.append(f"{path}: en az {s['minItems']} öğe olmalı")
            if "maxItems" in s and len(x) > s["maxItems"]:
                out.append(f"{path}: en çok {s['maxItems']} öğe olmalı (bulunan {len(x)})")
            if s.get("uniqueItems") and len({repr(i) for i in x}) != len(x):
                out.append(f"{path}: öğeler benzersiz olmalı")
            if "items" in s:
                for i, item in enumerate(x):
                    self._v(item, s["items"], f"{path}[{i}]", out)
        if isinstance(x, dict):
            for k in s.get("required", []):
                if k not in x:
                    out.append(f"{path}: zorunlu alan eksik: {k}")
            props = s.get("properties", {})
            for k, v in x.items():
                if k in props:
                    self._v(v, props[k], f"{path}.{k}", out)
                elif "additionalProperties" in s:
                    ap = s["additionalProperties"]
                    if ap is False:
                        out.append(f"{path}: tanımsız alan: {k}")
                    elif isinstance(ap, dict):
                        self._v(v, ap, f"{path}.{k}", out)
        for sub in s.get("allOf", []):
            self._v(x, sub, path, out)
        if "anyOf" in s:
            if not any(not self._sub(x, sub, path) for sub in s["anyOf"]):
                out.append(f"{path}: anyOf seçeneklerinden hiçbirine uymuyor")
        if "oneOf" in s:
            results = [self._sub(x, sub, path) for sub in s["oneOf"]]
            ok = sum(1 for r in results if not r)
            if ok != 1:
                if ok == 0:
                    # Ayırt edici "type" alanı varsa yalnızca o dalın hatalarını göster.
                    branch = self._branch_for(x, s["oneOf"])
                    if branch is not None:
                        out.extend(results[branch])
                    else:
                        out.append(f"{path}: oneOf seçeneklerinden hiçbirine uymuyor")
                else:
                    out.append(f"{path}: oneOf seçeneklerinden birden çoğuna uyuyor")
        if "if" in s:
            if not self._sub(x, s["if"], path):
                if "then" in s:
                    self._v(x, s["then"], path, out)
            elif "else" in s:
                self._v(x, s["else"], path, out)

    def _sub(self, x: Any, s: Any, path: str) -> list[str]:
        out: list[str] = []
        self._v(x, s, path, out)
        return out

    def _branch_for(self, x: Any, branches: list) -> int | None:
        if not isinstance(x, dict) or "type" not in x:
            return None
        for i, b in enumerate(branches):
            sch = self._resolve(b["$ref"]) if "$ref" in b else b
            const = sch.get("properties", {}).get("type", {}).get("const")
            if const == x["type"]:
                return i
        return None
