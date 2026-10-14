// hiVelzon editör onay ekranı (H-041). Çerçevesiz, bağımlılıksız. Veriler yalnızca textContent ile yazılır
// (innerHTML yok); CSP satır içi betiğe izin vermez. Belirteçler sekme oturumunda (sessionStorage) durur,
// sekme kapanınca silinir; "Çıkış" sunucudaki oturumu da kapatır.
(function () {
  'use strict';

  var API = '/api/v1';
  var ZONE = 'Europe/Istanbul';
  var KEY_ACCESS = 'hv.admin.access';
  var KEY_REFRESH = 'hv.admin.refresh';

  var STATUS = {
    DRAFT: 'Taslak', IN_REVIEW: 'İncelemede', APPROVED: 'Onaylı', SCHEDULED: 'Zamanlandı',
    PUBLISHED: 'Yayında', ARCHIVED: 'Arşivde', WITHDRAWN: 'Kaldırıldı'
  };
  var AUDIT = {
    CONTENT_SUBMITTED: 'İncelemeye gönderildi', CONTENT_APPROVED: 'Onaylandı', CONTENT_SCHEDULED: 'Zamanlandı',
    CONTENT_PUBLISHED: 'Yayınlandı', CONTENT_ARCHIVED: 'Arşivlendi', CONTENT_WITHDRAWN: 'Kaldırıldı'
  };
  var REASONS = {
    COPYRIGHT: 'Telif şikâyeti', CONTENT_ERROR: 'İçerik hatası', SAFETY: 'Güvenlik ya da yaş uygunluğu', OTHER: 'Diğer'
  };
  var MISSING = {
    lintReport: 'lint raporu yok ya da paketten eski',
    lintErrors: 'lint hataları var',
    translationFileApproved: 'ceviri.tr.json onaylı değil',
    canonChecked: 'kanon maddesi', levelChecked: 'seviye maddesi', translationApproved: 'çeviri maddesi',
    mediaChecked: 'medya maddesi', rightsAndAiDisclosureChecked: 'haklar ve AI maddesi'
  };

  var GENRES = {
    mystery: 'Gizem', adventure: 'Macera', humor: 'Mizah', 'scifi-fantasy': 'Bilimkurgu/fantastik',
    everyday: 'Günlük hayat/duygu'
  };

  // Bölüm: "S1 · B3"; kitap (H-070): "Kitap · A1 · K01".
  function place(item) {
    if (item.contentType === 'BOOK') { return 'Kitap · ' + item.level + ' · K' + (item.number < 10 ? '0' : '') + item.number; }
    return 'S' + item.season + ' · B' + item.number;
  }

  var $ = function (id) { return document.getElementById(id); };
  var current = null; // açık sürüm (AdminItem)

  // ------------------------------------------------------------------ oturum

  function store(key, value) {
    try { if (value) { sessionStorage.setItem(key, value); } else { sessionStorage.removeItem(key); } } catch (e) { /* yok */ }
  }
  function read(key) {
    try { return sessionStorage.getItem(key); } catch (e) { return null; }
  }

  function request(method, path, body, token) {
    var headers = { 'Accept': 'application/json' };
    if (token) { headers.Authorization = 'Bearer ' + token; }
    if (body !== undefined) { headers['Content-Type'] = 'application/json'; }
    return fetch(API + path, {
      method: method, headers: headers, credentials: 'omit', cache: 'no-store',
      body: body === undefined ? undefined : JSON.stringify(body)
    }).then(function (res) {
      return res.text().then(function (text) {
        var data = null;
        try { data = text ? JSON.parse(text) : null; } catch (e) { data = null; }
        return { status: res.status, ok: res.ok, data: data };
      });
    });
  }

  function refreshTokens() {
    var refresh = read(KEY_REFRESH);
    if (!refresh) { return Promise.resolve(false); }
    return request('POST', '/auth/refresh', { refreshToken: refresh }).then(function (r) {
      if (!r.ok || !r.data) { store(KEY_ACCESS, null); store(KEY_REFRESH, null); return false; }
      store(KEY_ACCESS, r.data.accessToken);
      store(KEY_REFRESH, r.data.refreshToken);
      return true;
    });
  }

  // Yetkili çağrı: 401'de bir kez yeniler, olmazsa girişe döner.
  function api(method, path, body) {
    return request(method, path, body, read(KEY_ACCESS)).then(function (r) {
      if (r.status !== 401) { return r; }
      return refreshTokens().then(function (ok) {
        if (!ok) { showLogin('Oturumun sona erdi. Yeniden giriş yap.'); throw new Error('auth'); }
        return request(method, path, body, read(KEY_ACCESS));
      });
    });
  }

  function problemText(r) {
    if (r.data && r.data.detail) {
      var text = r.data.detail;
      if (r.data.missing && r.data.missing.length) {
        text += ' Eksik: ' + r.data.missing.map(function (m) { return MISSING[m] || m; }).join(', ') + '.';
      }
      return text + (r.data.code ? ' (' + r.data.code + ')' : '');
    }
    return 'Beklenmeyen bir sorun oldu (HTTP ' + r.status + ').';
  }

  // ------------------------------------------------------------------ görünüm yardımcıları

  function show(view) {
    ['login-view', 'list-view', 'detail-view'].forEach(function (id) { $(id).hidden = id !== view; });
    $('nav').hidden = view === 'login-view';
  }
  function setError(text) { $('error').textContent = text || ''; $('error').hidden = !text; }
  function setInfo(text) { $('info').textContent = text || ''; $('info').hidden = !text; }
  function clear(el) { while (el.firstChild) { el.removeChild(el.firstChild); } }
  function cell(row, text) { var td = document.createElement('td'); td.textContent = text; row.appendChild(td); return td; }
  function chip(status) {
    var s = document.createElement('span');
    s.className = 'chip s-' + status;
    s.textContent = STATUS[status] || status;
    return s;
  }
  function fmt(iso) {
    if (!iso) { return '—'; }
    return new Intl.DateTimeFormat('tr-TR', {
      timeZone: ZONE, year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit'
    }).format(new Date(iso));
  }
  function lintText(item) {
    if (item.lintErrors === null || item.lintErrors === undefined) { return 'rapor yok'; }
    return item.lintErrors + ' hata, ' + item.lintWarnings + ' uyarı';
  }
  function busy(on) {
    Array.prototype.forEach.call(document.querySelectorAll('button'), function (b) { b.disabled = on; });
  }

  // ------------------------------------------------------------------ giriş

  var pendingEmail = null;

  function showLogin(message) {
    store(KEY_ACCESS, null);
    show('login-view');
    $('verify-form').hidden = true;
    $('start-form').hidden = false;
    setInfo(null);
    setError(message || null);
  }

  $('start-form').addEventListener('submit', function (ev) {
    ev.preventDefault();
    setError(null);
    pendingEmail = $('email').value.trim();
    busy(true);
    request('POST', '/auth/email/start', { email: pendingEmail }).then(function (r) {
      busy(false);
      if (r.status !== 202) { setError(problemText(r)); return; }
      $('start-form').hidden = true;
      $('verify-form').hidden = false;
      setInfo('Kod e-postana gönderildi.');
      $('code').focus();
    }).catch(function () { busy(false); setError('Sunucuya ulaşılamadı.'); });
  });

  $('verify-form').addEventListener('submit', function (ev) {
    ev.preventDefault();
    setError(null);
    busy(true);
    request('POST', '/auth/email/verify', {
      email: pendingEmail, code: $('code').value.trim(), deviceName: 'Editör ekranı'
    }).then(function (r) {
      busy(false);
      if (r.status === 422 && r.data && r.data.code === 'SIGNUP_DETAILS_REQUIRED') {
        setError('Bu e-postayla bir hesap yok. Editör ekranından hesap açılmaz.');
        return;
      }
      if (!r.ok) { setError(problemText(r)); return; }
      store(KEY_ACCESS, r.data.accessToken);
      store(KEY_REFRESH, r.data.refreshToken);
      $('code').value = '';
      setInfo(null);
      start();
    }).catch(function () { busy(false); setError('Sunucuya ulaşılamadı.'); });
  });

  $('logout').addEventListener('click', function () {
    var refresh = read(KEY_REFRESH);
    store(KEY_REFRESH, null);
    var done = function () { showLogin(null); location.hash = '#/'; };
    if (refresh) { request('POST', '/auth/logout', { refreshToken: refresh }).then(done, done); } else { done(); }
  });

  // Oturum varsa rolü denetler, sonra yönlendirir.
  function start() {
    if (!read(KEY_ACCESS) && !read(KEY_REFRESH)) { showLogin(null); return; }
    api('GET', '/me').then(function (r) {
      if (!r.ok) { showLogin(problemText(r)); return; }
      if (r.data.role !== 'EDITOR' && r.data.role !== 'ADMIN') {
        showLogin('Bu hesabın editör yetkisi yok.');
        return;
      }
      $('who').textContent = (r.data.displayName || r.data.email) + ' · ' + r.data.role;
      route();
    }).catch(function () { /* girişe dönüldü */ });
  }

  // ------------------------------------------------------------------ liste

  function loadList() {
    show('list-view');
    var season = $('season').value;
    var query = season === 'books' ? '?type=BOOK' : (season ? '?type=EPISODE&season=' + encodeURIComponent(season) : '');
    api('GET', '/admin/content/items' + query).then(function (r) {
      if (!r.ok) { setError(problemText(r)); return; }
      var body = $('items');
      clear(body);
      $('empty').hidden = r.data.length > 0;
      r.data.forEach(function (item) {
        var tr = document.createElement('tr');
        cell(tr, place(item));
        var idCell = cell(tr, '');
        var a = document.createElement('a');
        a.href = '#/item/' + encodeURIComponent(item.contentId) + '/' + item.contentVersion;
        a.textContent = item.contentId;
        idCell.appendChild(a);
        cell(tr, 'v' + item.contentVersion);
        cell(tr, item.title);
        cell(tr, '').appendChild(chip(item.status));
        cell(tr, item.visible ? 'Evet' : 'Hayır');
        cell(tr, lintText(item));
        cell(tr, fmt(item.publishAt));
        body.appendChild(tr);
      });
    }).catch(function () { /* girişe dönüldü */ });
  }

  $('season').addEventListener('change', loadList);
  $('reload').addEventListener('click', function () { setInfo(null); setError(null); loadList(); });
  $('import').addEventListener('click', function () {
    setError(null);
    busy(true);
    api('POST', '/admin/catalog/import').then(function (r) {
      busy(false);
      if (r.status === 404) { setError('İçe aktarma bu ortamda kapalı (yalnızca geliştirme).'); return; }
      if (!r.ok) { setError(problemText(r)); return; }
      setInfo('İçe aktarıldı: ' + r.data.created + ' yeni, ' + r.data.updated + ' güncellendi, '
        + r.data.unchanged + ' değişmedi, ' + r.data.skipped + ' atlandı.');
      loadList();
    }).catch(function () { busy(false); });
  });

  // ------------------------------------------------------------------ ayrıntı

  function fact(dl, label, value) {
    var dt = document.createElement('dt'); dt.textContent = label; dl.appendChild(dt);
    var dd = document.createElement('dd');
    if (value instanceof Node) { dd.appendChild(value); } else { dd.textContent = value; }
    dl.appendChild(dd);
  }

  function loadDetail(contentId, version) {
    show('detail-view');
    api('GET', '/admin/content/items/' + encodeURIComponent(contentId) + '/versions/' + encodeURIComponent(version))
      .then(function (r) {
        if (!r.ok) { setError(problemText(r)); return; }
        renderDetail(r.data);
      }).catch(function () { /* girişe dönüldü */ });
  }

  function renderDetail(detail) {
    var item = detail.item;
    current = item;
    $('detail-title').textContent = item.contentId + ' v' + item.contentVersion + ' · ' + item.title;
    var dl = $('facts');
    clear(dl);
    fact(dl, 'Durum', chip(item.status));
    fact(dl, 'Katalogda görünür', item.visible ? 'Evet' : 'Hayır');
    if (item.contentType === 'BOOK') {
      fact(dl, 'Kitap · seviye · tür', place(item) + ' · ' + (GENRES[item.genre] || item.genre));
    } else {
      fact(dl, 'Sezon · bölüm · seviye', place(item) + ' · ' + item.level);
    }
    fact(dl, 'Lint', lintText(item) + (item.lintCheckedAt ? ' (' + fmt(item.lintCheckedAt) + ')' : ''));
    fact(dl, 'Çeviri dosyası', item.translationStatus || 'yok');
    fact(dl, 'Yayın zamanı', fmt(item.publishAt));
    fact(dl, 'Onay', item.approvedAt ? fmt(item.approvedAt) + ' · liste ' + item.checklistSha256.substring(0, 12) : '—');
    if (item.withdrawReason) { fact(dl, 'Kaldırma gerekçesi', REASONS[item.withdrawReason] || item.withdrawReason); }
    fact(dl, 'İçe aktarma', fmt(item.importedAt));
    fact(dl, 'Paket özeti (manifest)', item.manifestSha256.substring(0, 16) + '…');

    var allowed = item.allowedActions || [];
    $('act-submit').hidden = allowed.indexOf('SUBMIT') < 0;
    $('act-approve').hidden = allowed.indexOf('APPROVE') < 0;
    $('act-schedule').hidden = allowed.indexOf('SCHEDULE') < 0;
    $('act-publish').hidden = allowed.indexOf('PUBLISH') < 0;
    $('act-archive').hidden = allowed.indexOf('ARCHIVE') < 0;
    $('act-withdraw').hidden = allowed.indexOf('WITHDRAW') < 0;
    Array.prototype.forEach.call(document.querySelectorAll('#act-approve input[type=checkbox]'),
      function (c) { c.checked = false; });
    // Kitaplar hikâye kanonuna bağlı değil: kanon maddesi sorulmaz (H-070).
    $('canon-item').hidden = item.contentType === 'BOOK';
    $('reason').value = '';
    $('publish-at').value = '';

    var body = $('history');
    clear(body);
    if (!detail.history.length) {
      var tr0 = document.createElement('tr');
      var td = cell(tr0, 'Henüz editör işlemi yok.');
      td.colSpan = 4;
      body.appendChild(tr0);
    }
    detail.history.forEach(function (h) {
      var tr = document.createElement('tr');
      cell(tr, fmt(h.at));
      cell(tr, AUDIT[h.action] || h.action);
      cell(tr, h.actor);
      cell(tr, h.detail);
      body.appendChild(tr);
    });
  }

  function transition(payload, confirmText) {
    if (!current) { return; }
    if (confirmText && !window.confirm(confirmText)) { return; }
    setError(null);
    setInfo(null);
    payload.expectedLockVersion = current.lockVersion;
    busy(true);
    api('POST', '/admin/content/items/' + encodeURIComponent(current.contentId) + '/versions/'
      + current.contentVersion + '/transitions', payload).then(function (r) {
      busy(false);
      if (!r.ok) { setError(problemText(r)); return; }
      renderDetail(r.data);
      setInfo('Kaydedildi: ' + (STATUS[r.data.item.status] || r.data.item.status) + '.');
    }).catch(function () { busy(false); });
  }

  $('btn-submit').addEventListener('click', function () { transition({ action: 'SUBMIT' }); });
  $('btn-approve').addEventListener('click', function () {
    var checklist = {};
    Array.prototype.forEach.call(document.querySelectorAll('#act-approve input[type=checkbox]'),
      function (c) { if (!(c.name === 'canonChecked' && $('canon-item').hidden)) { checklist[c.name] = c.checked; } });
    transition({ action: 'APPROVE', checklist: checklist });
  });
  $('btn-schedule').addEventListener('click', function () {
    var local = $('publish-at').value;
    if (!local) { setError('Yayın zamanını seç.'); return; }
    transition({ action: 'SCHEDULE', publishAtLocal: local });
  });
  $('btn-publish').addEventListener('click', function () {
    transition({ action: 'PUBLISH' }, 'Bu sürüm hemen katalogda görünecek. Yayınlansın mı?');
  });
  $('btn-archive').addEventListener('click', function () {
    transition({ action: 'ARCHIVE' }, 'Bu sürüm katalogdan çıkacak. Arşivlensin mi?');
  });
  $('btn-withdraw').addEventListener('click', function () {
    var reason = $('reason').value;
    if (!reason) { setError('Kaldırma gerekçesini seç.'); return; }
    transition({ action: 'WITHDRAW', reason: reason },
      'Bu sürüm katalogdan hemen kalkacak ve geri alınamaz (yeni sürüm gerekir). Kaldırılsın mı?');
  });

  // ------------------------------------------------------------------ yönlendirme

  function route() {
    setError(null);
    var m = /^#\/item\/([A-Z0-9-]+)\/(\d+)$/.exec(location.hash);
    if (m) { loadDetail(decodeURIComponent(m[1]), m[2]); } else { setInfo(null); loadList(); }
  }

  window.addEventListener('hashchange', function () { if (read(KEY_ACCESS) || read(KEY_REFRESH)) { route(); } });
  start();
})();
