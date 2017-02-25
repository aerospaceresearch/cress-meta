#!/usr/bin/python3

# monitor if all boxes are working
import os.path
import requests


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
    def pushover(self):
        return {
            'user': self._extract_from_config('pushover_user'),
            'token': self._extract_from_config('pushover_token')
        }

    @property
    def header(self):
        return {
            "Authorization": "Token {}".format(self.token)
        }


def get_boxes():
    url = "https://cress.space/v1/box/"
    r = requests.get(url, headers=Config().header)

    sensors_per_box = {}
    for box in r.json():
        sensors_per_box[box.get('id')] = len(box.get('sensors'))
    return sensors_per_box


def send_to_pushover(message):
    requests.post("https://api.pushover.net/1/messages.json",
                  data={'token': Config().pushover.get('token'),
                        'user': Config().pushover.get('user'),
                        'message': message})


sensors_per_box = get_boxes()
if any([i==0 for i in sensors_per_box.values()]):
    send_to_pushover("One box is offline? - " + str(sensors_per_box))
