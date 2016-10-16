#!/usr/bin/python

# usage: updateAction.py

# gets current FC28 sensor value of box
# gets current action
# updates action if necessary
import os.path
import requests


base_url = "https://cress.space"


class Config():

    def _extract_from_config(self, variable):
        ## read token from config.sh
        fn = os.path.join(os.path.dirname(__file__), "config.sh")
        with open(fn) as fp:
            for line in fp.readlines():
                if '=' in line:
                    if line.split('=')[0] == variable:
                        return line.split('=')[1].strip()

    @property
    def token(self):
        return self._extract_from_config('csTOKEN')

    @property
    def box(self):
        return self._extract_from_config('csBOX')

    @property
    def water_limit(self):
        return self._extract_from_config('csWaterLimit')

    @property
    def header(self):
        return {
            "Authorization": "Token {}".format(self.token)
        }


def get_watermark():
    url = base_url + "/v1/box/{}/".format(Config().box)
    r = requests.get(url, headers=Config().header)

    for sensor in r.json().get('sensors'):
        if sensor['sensor_type'] == 'FC28' and sensor['value_type'] == 'watermark':
            return sensor['value']


def get_action():
    url = base_url + "/v1/action/{}/".format(Config().box)
    r = requests.get(url, headers=Config().header)
    print(r.json())
    for action in r.json().get('action', []):
        if action['action_type'] == 'Water':
            return action['decision']


def update_action(data):
    url = base_url + "/v1/action/"
    data['box'] = Config().box
    r = requests.post(url, headers=Config().header, data=data)


def get_cycle_default():
    url = base_url + "/v1/box/{}/".format(Config().box)
    r = requests.get(url, headers=Config().header)
    return r.json().get('defaults', {}).get('water')


def rulesystem():
    watermark = int(get_watermark())
    decision = int(get_action())
    data = {
        'action_type': 'Water',
        'decision': 0,
    }
    if watermark > Config().water_limit and decision > 0:
        print('set decision to 0')
        update_action(data)
    elif watermark < Config().water_limit and decision == 0:
        print('set decision to default')
        data['decision'] = get_cycle_default()
        update_action(data)
    else:
        print('nothing changed')


rulesystem()
