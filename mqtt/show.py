# -*- coding: utf-8 -*-

import paho.mqtt.client as mqtt
import datetime
import requests

_state = {}


def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe("home-assistant/#")


def on_message(client, userdata, msg):
    print(msg.topic)


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect("hass.shack", 1883, 60)

client.loop_forever()
