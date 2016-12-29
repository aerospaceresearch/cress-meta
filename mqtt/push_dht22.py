# -*- coding: utf-8 -*-

import paho.mqtt.client as mqtt
import datetime
import requests

_state = {}


def get_token_from_config():
    ## read token from config.sh
    with open("/home/pi/src/config.sh") as fp:
        for line in fp.readlines():
            if '=' in line:
                if line.split('=')[0] == 'csTOKEN':
                    return line.split('=')[1].strip()


## config
token = get_token_from_config()
esp_serialnumber = "10654227"
print("using token: {}".format(token))


def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe("home-assistant/{}/#".format(esp_serialnumber))


def on_message(client, userdata, msg):
    minute = datetime.datetime.now().minute
    print(minute),
    if minute % 5 == 0:
        if not (_state.get(msg.topic, -1) == minute):
            _state[msg.topic] = minute
            payload = {
                'box': 3,
                'sensor_type': 'DHT22',
                'position': 'outside',
                'value': str(msg.payload),
            }
            if msg.topic.endswith('humidity'):
                payload.update({
                    'value_type': 'humidity',
                    'unit': '%',
                })
            elif msg.topic.endswith('temperature'):
                payload.update({
                    'value_type': 'temperature',
                    'unit': u'°C',
                })
            headers = {
                "Authorization": "Token {}".format(token)
            }
            r = requests.post("https://cress.space/v1/sensor/", headers=headers, json=payload)
            print("pushed")
    print(msg.payload)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect("hass.shack", 1883, 60)

client.loop_forever()
