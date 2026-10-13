package tr.velzon.hivelzon.support;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Proxy;
import java.sql.Connection;
import java.util.concurrent.atomic.AtomicLong;

import javax.sql.DataSource;

import org.springframework.beans.factory.config.BeanPostProcessor;

/**
 * N+1 denetimi için SQL ifade sayacı (JDBC ve Hibernate dahil): DataSource'tan alınan bağlantılarda
 * hazırlanan / oluşturulan her ifadeyi sayar. Yalnızca test.
 */
public class QueryCounter implements BeanPostProcessor {

    private static final AtomicLong STATEMENTS = new AtomicLong();

    public static void reset() {
        STATEMENTS.set(0);
    }

    public static long count() {
        return STATEMENTS.get();
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) {
        if (bean instanceof DataSource ds && !(Proxy.isProxyClass(bean.getClass()))) {
            return Proxy.newProxyInstance(getClass().getClassLoader(), new Class<?>[] {DataSource.class},
                    handler(ds, true));
        }
        return bean;
    }

    private static InvocationHandler handler(Object target, boolean dataSource) {
        return (proxy, method, args) -> {
            Object result;
            try {
                result = method.invoke(target, args);
            } catch (InvocationTargetException e) {
                throw e.getCause();
            }
            if (dataSource && result instanceof Connection c && method.getName().equals("getConnection")) {
                return Proxy.newProxyInstance(QueryCounter.class.getClassLoader(), new Class<?>[] {Connection.class},
                        handler(c, false));
            }
            if (!dataSource && (method.getName().equals("prepareStatement")
                    || method.getName().equals("createStatement") || method.getName().equals("prepareCall"))) {
                STATEMENTS.incrementAndGet();
            }
            return result;
        };
    }
}
