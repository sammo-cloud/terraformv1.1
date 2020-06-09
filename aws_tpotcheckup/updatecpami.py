#!/usr/bin/python3

import sys, os, requests, uuid, json

url = "https://s3.amazonaws.com/CloudFormationTemplate/amis.json"

r = requests.get(url)
data = r.json()
for region in data['Mappings']['RegionMap']:
    print("\"%s\" = \"%s\"" % (region,data['Mappings']['RegionMap'][region]['R8040BYOLMGMT']))
