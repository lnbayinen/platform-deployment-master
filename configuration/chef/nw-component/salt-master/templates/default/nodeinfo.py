import salt
import os
import ConfigParser
import StringIO

parser = ConfigParser.RawConfigParser()
service_id_dict = {}

NODE_INFO_DIRECTORY = "/etc/netwitness/platform/nodeinfo"
SERVICE_ID_FILE_NAME = "service-id"
SERVICE_ID_PROP_NAME = "service-id"

def service_ids():
  if os.path.exists(NODE_INFO_DIRECTORY):
    for service_directory in os.listdir(NODE_INFO_DIRECTORY):
      service_dir_path = os.path.join(NODE_INFO_DIRECTORY, service_directory)
      if os.path.isdir(service_dir_path):
	service_id_path = os.path.join(service_dir_path, SERVICE_ID_FILE_NAME)
	with open(service_id_path, 'r') as service_id_file:
	  service_id_file = StringIO.StringIO("[top]\n" + service_id_file.read())
	  parser.readfp(service_id_file)
	  uuid = parser.get('top', SERVICE_ID_PROP_NAME)
	  if uuid:
	    service_id_dict[service_directory] = uuid
  return service_id_dict


def service_id(service_name = ""):
  service_dir_path = os.path.join(NODE_INFO_DIRECTORY, service_name)
  if os.path.isdir(service_dir_path):
    service_id_path = os.path.join(service_dir_path, SERVICE_ID_FILE_NAME)
    with open(service_id_path, 'r') as service_id_file:
      service_id_file = StringIO.StringIO("[top]\n" + service_id_file.read())
      parser.readfp(service_id_file)
      uuid = parser.get('top', SERVICE_ID_PROP_NAME)
      if uuid:
        service_id_dict[service_name] = uuid
  return service_id_dict