####################################################################
# label_manager.src.cli.py
####################################################################
# GitHub Repository Label Manager
#
# File:         cli.py
# Package:      label_manager
# Author:       Ragdata
# Date:         14/10/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# ATTRIBUTION
####################################################################
# This package borrows heavily from the following public domain project:
# https://github.com/mloskot/github-label-maker
# Written by Mateusz Loskot <mateusz at loskot dot net>
####################################################################
# DEPENDENCIES
####################################################################
import argparse
import json
import logging
import os
import sys

# this package
import label_manager

def run():
    ap = argparse.ArgumentParser(description="Create labels from definitions in labels/*.json or restore default set from labels/default.json")
    ap.add_argument('-l', '--level', help='Set logging level', action='store_true')
    ap.add_argument('-o', '--owner', help='GitHub repository owner', required=True)
    ap.add_argument('-r', '--repository', help='GitHub repository', required=True)
    ap.add_argument('-t', '--token', help='GitHub Personal Access Token (if not set as GITHUB_ACCESS_TOKEN environment variable)')
    ap.add_argument('-c', '--clear', help='Clear (delete) all labels from this repository', action='store_true')
    ap.add_argument('-m', '--make', help='Create labels from definitions stored in the specified JSON file or directory of files')
    ap.add_argument('-d', '--dump', help='Dump current repository labels to JSON file')

    args = ap.parse_args()

    if args.level:
        label_manager.set_log_level(args.level)

    if not args.token:
        if 'GITHUB_ACCESS_TOKEN' in os.environ:
            logging.info("reading GITHUB_ACCESS_TOKEN from environment")
            args.token = os.environ['GITHUB_ACCESS_TOKEN']
        else:
            script_dir = os.path.dirname(os.path.realpath(__file__))
            token_file = os.path.join(script_dir, '.token')
            if os.path.isfile(token_file):
                with open(token_file) as f:
                    args.token = f.readline()
    assert args.token, "A Github Token is required for successful authentication"
    assert args.clear or args.make or args.dump

    hub = label_manager.LabelManager(args.token, args.owner, args.repository, args.level)

    if args.clear:
        logging.info("deleting all labels from '{0}/{1}'".format(args.owner, args.repository))
        hub.clear()
    elif args.dump:
        assert args.dump.endswith('json')
        labels_def = hub.getLabels()
        if labels_def:
            logging.info("dumping labels for '{0}/{1}' to '{2}'".format(args.owner, args.repository, args.dump))
            with open(args.dump, 'w') as f:
                labels_def = json.dumps(labels_def, indent=4)
                f.write(labels_def)
        else:
            logging.info("no labels found")
    else:
        if os.path.isdir(args.make):
            labels_dir = args.make
            labels_def_files = [
                os.path.join(labels_dir, f)
                    for f in os.listdir(labels_dir) if f.endswith('json')
            ]
        else:
            assert os.path.isfile(args.make)
            labels_def_files = [ args.make ]

        for labels_file in labels_def_files:
            logging.info("creating labels from '%s'", labels_file)
            with open(labels_file, 'r') as f:
                labels_def = json.load(f)
                hub.updateLabels(labels_def)


if __name__ == "__main__":
    run()
