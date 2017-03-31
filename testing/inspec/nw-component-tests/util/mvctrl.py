#!/usr/bin/env python

# This script is used to generate a list of InSpec tests based on a node.json run list.
# All InSpec tests are located in /path/to/inspec_profile/all-tests. This script
# will copy the appropriate files from controls-all to the controls directory.
# Author: George Spanos <Georgios.Spanos@rsa.com>

import json, shutil, re, sys
from optparse import OptionParser


if __name__ == "__main__":
    parser = OptionParser()
    parser.add_option("-f", "--file", dest="node_file",
                        help="Path to node.json", metavar="/path/to/node.json")
    parser.add_option("-p", "--profile", dest="profile_path",
                        help="Path to InSpec profile", metavar="/path/to/profile")

    (options, args) = parser.parse_args()

    if not options.node_file:
        print "Must provide path to node.json"
        sys.exit(1)

    if not options.profile_path:
        print "Must provide path to InSpec profile"
        sys.exit(1)

    try:
        with open(options.node_file) as json_file:
            json_data = json.load(json_file)
    except Exception as e:
        print e
        sys.exit(1)
    try:
        for recipe in json_data['run_list']:
            # Remove the "receipe[" substring
            prefix_remove = re.sub('recipe\[','', recipe)
            # Remove the "]" substring
            postfix_remove = re.sub('\]', '', prefix_remove)
            clean_text = postfix_remove
            # In cases there is a receipe[name::class] split the string
            if '::' in clean_text:
                clean_text_array = clean_text.split('::')
                clean_text = clean_text_array[0]
            source_path = options.profile_path + \
                          "/all-tests/" + clean_text + '.rb'
            dest_path = options.profile_path + \
                          "/controls/" + clean_text + '.rb'
            shutil.copy2( source_path, dest_path )
    except Exception as e:
        print e
        sys.exit(1)
