####################################################################
# label_manager.src.label_manager.py
####################################################################
# GitHub Repository Label Manager
#
# File:         label_manager.py
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
import logging
import github
import github.GithubObject

def set_log_level(loglevel=logging.INFO):
    logging.basicConfig(level=loglevel)

class LabelManager:

    def __init__(self, github_token, github_owner, github_repo, level=logging.INFO):
        assert isinstance(github_owner, str)
        assert isinstance(github_repo, str)

        set_log_level(level)

        gh = github.Github(github_token)

        assert gh.get_user().login
        logging.info("authorised to github as user '{0}'".format(gh.get_user().login))

        rate_limit = gh.get_rate_limit()
        logging.info("rate limit = {0}, remaining = {1}".format(rate_limit.core.limit, rate_limit.core.remaining))

        # Repository is owned by user or one of user's orgs
        orgs = [org.login for org in gh.get_user().get_orgs()]
        if github_owner in orgs:
            owner = gh.get_organization(github_owner)
        else:
            owner = gh.get_user()

        repos = owner.get_repos()
        self._repo = [repo for repo in repos if github_repo == repo.name][0]
        logging.info("connected to repository '{0}/{1}'".format(owner.login, self._repo.name))

    def _find_label(self, name):
        try:
            if name is None:
                name = ''
            return self._repo.get_label(name)
        except github.UnknownObjectException as e:
            logging.info(e)
            logging.info("label '{0}' not found".format(name))
            return None

    @staticmethod
    def _get_labels_def(labels_from):
        assert labels_from
        if isinstance(labels_from, dict):
            labels_def = [labels_from]
        else:
            labels_def = labels_from
        assert isinstance(labels_from, list)
        assert isinstance(labels_from[0], dict)
        return labels_def

    @staticmethod
    def _get_label_properties(label_def):
        assert isinstance(label_def, dict)
        assert 'name' in label_def
        assert 'color' in label_def
        name = label_def['name']
        color = label_def['color']
        if color.startswith('#'):
            color = color[1:]
        description = github.GithubObject.NotSet
        if 'description' in label_def:
            description = label_def['description']
        old_name = name
        if old_name in label_def:
            old_name = label_def['old_name']
        elif 'current_name' in label_def:
            old_name = label_def['current_name']
        return name, color, description, old_name

    def addLabel(self, label_def):
        name, color, description, *_ = self._get_label_properties(label_def)
        logging.info("adding label '{0}'".format(name))
        self._repo.create_label(name, color, description)

    def addLabels(self, labels_def):
        labels_def = self._get_labels_def(labels_def)
        for label_def in labels_def:
            self.addLabel(labels_def)

    def clear(self):
        for label in self._repo.get_labels():
            logging.info("deleting label '{0}'".format(label.name))
            label.delete()

    def deleteLabel(self, label_def_or_name):
        if isinstance(label_def_or_name, str):
            name = label_def_or_name
        else:
            name, *_ = self._get_label_properties(label_def_or_name)
        label = self._find_label(name)
        if label:
            logging.info("deleting label '{0}'".format(name))
            label.delete()
            return True
        else:
            return False

    def deleteLabels(self, labels_def_or_names):
        for def_or_name in labels_def_or_names:
            self.deleteLabel(def_or_name)

    def editLabel(self, label_def):
        name, color, description, old_name = self._get_label_properties(label_def)
        label = self._find_label(old_name)
        if label:
            logging.info("editing label '{0}' as '{1}'".format(old_name, name))
        else:
            label = self._find_label(name)
            if label:
                logging.info("editing label '{0}'".format(name))

        if label:
            label.edit(name, color, description)
            return True
        else:
            logging.info("label '{0}' not found to edit as '{1}'".format(old_name, name))
            return False

    def editLabels(self, labels_def):
        labels_def = self._get_labels_def(labels_def)
        for label_def in labels_def:
            self.editLabel(label_def)

    def getLabel(self, name):
        label = self._find_label(name)
        if not label:
            logging.info("label '{0}' not found".format(name))
        label_def = { "name": label.name, "color": "#{0}".format(label.color) }
        if label.description is not github.GithubObject.NotSet:
            label_def['description'] = label.description
        return label_def

    def getLabels(self):
        labels_def = []
        repo_labels = self._repo.get_labels()
        for label in repo_labels:
            label_def = { "name": label.name, "color": "#{0}".format(label.color) }
            if label.description is not github.GithubObject.NotSet:
                label_def['description'] = label.description
            labels_def.append(label_def)
        return labels_def

    def updateLabel(self, label_def):
        if not self.editLabel(label_def):
            self.addLabel(label_def)

    def updateLabels(self, labels_def):
        for label_def in labels_def:
            self.updateLabel(label_def)
