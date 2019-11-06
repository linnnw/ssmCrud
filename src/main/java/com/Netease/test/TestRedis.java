package com.Netease.test;

import org.junit.Test;
import redis.clients.jedis.Jedis;

public class TestRedis {

    @Test
    public void demo(){
        Jedis jedis = new Jedis("127.0.0.1",6379);
        jedis.set("name","imooc");
        String name = jedis.get("name");
        System.out.println(name);
    }
}
