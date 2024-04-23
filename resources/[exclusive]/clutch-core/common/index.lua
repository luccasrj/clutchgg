-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")
vSKINSHOP = Tunnel.getInterface("skinshop")
