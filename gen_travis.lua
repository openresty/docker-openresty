#!/usr/bin/env lua
-- https://github.com/openresty/docker-openresty
--
-- Generates the .travis.yml file for CI building of this image
--
-- Requires etlua:  luarocks install etlua
--
-- ./gen_travis.lua > .travis.yml
--

local etlua = require "etlua"

local template_file = io.open("./travis.yml.etlua")
local template_str = template_file:read("*a")
template_file:close()

local template = etlua.compile(template_str)

print(template({
    flavors = {
        "alpine",
        "alpine-fat",
        "bionic",
        "centos",
        "centos-rpm",
        "jessie",
        "stretch",
        "trusty",
        "wheezy",
        "xenial"
    },
}))
