#!/usr/bin/env python

# sudo apt-get install python-pip libglib2.0-dev python-dev
# sudo pip install setuptools wheel
# sudo pip install bluepy
# sudo apt install libpq-dev
# sudo pip install psycopg2-binary

from datetime import datetime
import psycopg2
import sys
import bluepy.btle as btle

# https://www.psycopg.org/docs/usage.html
# https://github.com/IanHarvey/bluepy

class Reading:
    temp = 0
    light = 0
    humidity = 0
    battery = 0

    def __init__(self, temp, humidity, light, battery):
        self.temp = temp
        self.light = light
        self.humidity = humidity
        self.battery = battery

    def store(self):
        conn_string = "host='localhost' dbname='autowatererweb_production' user='miccet' password='welcome'"
        conn = psycopg2.connect(conn_string)
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO readings (temp, light, humidity, battery, happend, created_at, updated_at)
            VALUES (%s, %s, %s, %s, now() at time zone 'utc', now() at time zone 'utc', now() at time zone 'utc');""",
            [self.temp, self.light, self.humidity, self.battery])
        conn.commit()
        cursor.close()
        conn.close()

class ReadDelegate(btle.DefaultDelegate):
    def handleNotification(self, cHandle, data):
        str = data.decode("utf-8")
        global buffer
        buffer = buffer + str.strip()
        print('{}: Buffer is now "{}"'.format(datetime.now(), buffer))
        if "B:" in buffer:
            str = buffer
            buffer = ""
            print("{}: {}".format(datetime.now(), str))
            str = str.replace("T:", "").replace("H:", "").replace("L:", "").replace("B:", "")
            arr = str.split("|")
            reading = Reading(arr[0],arr[1],arr[2],arr[3])
            reading.store()
            #p.disconnect()

doRun = True
hasDevice = False
buffer = ""
device = "7C:01:0A:76:D9:6A"
p = False

while doRun:
    try:
        while not hasDevice:
            print('{}: Starting to listen to: "{}"'.format(datetime.now(), device))
            p = btle.Peripheral(device)
            p.withDelegate(ReadDelegate())
            hasDevice = True
        while p.waitForNotifications(10):
            pass
    except KeyboardInterrupt:
        doRun = False
    except Exception as e:
        print("{}: {}".format(datetime.now(), str(e)))
        hasDevice = False
	p = False
        pass

if not p == False:
  p.disconnect()

print("{}: Quitting...".format(datetime.now()))

