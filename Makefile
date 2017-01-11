
# This file installs ffurls.py and some scripts in the operating
# system, cleans temporary files and directory in the project.
#
# Copyright (C) 2017, Slava <nobody@nowhere>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Names section

PROG = ffurls

TARGET_PYTHON_SCRIPT = ffurls.py

TARGET_SHELL_SCRIPT_GENERAL = ffurls.sh

TARGET_SHELL_SCRIPT_TEXT = ffurls-text.sh
TARGET_RENAMED_SHELL_SCRIPT_TEXT = ffurlst.sh

TARGET_SHELL_SCRIPT_HTML = ffurls-html.sh
TARGET_RENAMED_SHELL_SCRIPT_HTML = ffurlsh.sh

TARGET_SHELL_SCRIPT_ORG = ffurls-org.sh
TARGET_RENAMED_SHELL_SCRIPT_ORG = ffurlso.sh

TEST_OUTPUT_FILES = file.txt file.html file.org
TEST_CACHE_DIR = __pycache__


# Build section

BUILD_DIR = build
VER_M4 = ver.m4


# Install section

home_dir = /home/guest
path_python_script = /usr/local/bin
path_shell_scripts = $(home_dir)/.env/scripts

PYTHON_SCRIPT_INSTALL_DIR = $(path_python_script)
SHELL_SCRIPTS_INSTALL_DIR = $(path_shell_scripts)


# Commands

help:
	@echo "usage: make [ build | clean | install | uninstall ]" 1>&2

build:
	@[ -d $(BUILD_DIR) ] $&& rm -rf $(BUILD_DIR)
	mkdir $(BUILD_DIR)

	@m4 -P $(VER_M4) $(TARGET_PYTHON_SCRIPT) > $(BUILD_DIR)/$(TARGET_PYTHON_SCRIPT)
	@chmod u+x $(BUILD_DIR)/$(TARGET_PYTHON_SCRIPT)

	@m4 -P $(VER_M4) $(TARGET_SHELL_SCRIPT_GENERAL) > $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_GENERAL)
	@chmod u+x $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_GENERAL)

	@m4 -P $(VER_M4) $(TARGET_SHELL_SCRIPT_TEXT) > $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_TEXT)
	@chmod u+x $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_TEXT)

	@m4 -P $(VER_M4) $(TARGET_SHELL_SCRIPT_HTML) > $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_HTML)
	@chmod u+x $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_HTML)

	@m4 -P $(VER_M4) $(TARGET_SHELL_SCRIPT_ORG) > $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_ORG)
	@chmod u+x $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_ORG)

	@echo "$(PROG) has built"

clean:
	@rm -rf $(TEST_OUTPUT_FILES) $(TEST_CACHE_DIR)
	@rm -rf $(BUILD_DIR)
	@echo "$(PROG) cleaned"

install: build
	install -d $(PYTHON_SCRIPT_INSTALL_DIR)
	install $(BUILD_DIR)/$(TARGET_PYTHON_SCRIPT) $(PYTHON_SCRIPT_INSTALL_DIR)/$(TARGET_PYTHON_SCRIPT)
	install -d $(SHELL_SCRIPTS_INSTALL_DIR)
	install $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_GENERAL) $(SHELL_SCRIPTS_INSTALL_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_GENERAL)
	install $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_TEXT) $(SHELL_SCRIPTS_INSTALL_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_TEXT)
	install $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_HTML) $(SHELL_SCRIPTS_INSTALL_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_HTML)
	install $(BUILD_DIR)/$(TARGET_SHELL_SCRIPT_ORG) $(SHELL_SCRIPTS_INSTALL_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_ORG)

uninstall:
	rm -f $(PYTHON_SCRIPT_INSTALL_DIR)/$(TARGET_PYTHON_SCRIPT)
	rm -f $(SHELL_SCRIPTS_INSTALL_DIR)/$(TARGET_SHELL_SCRIPT_GENERAL)
	rm -f $(SHELL_SCRIPTS_INSTALL_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_TEXT)
	rm -f $(SHELL_SCRIPTS_INSTALL_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_HTML)
	rm -f $(SHELL_SCRIPTS_INSTALL_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_ORG)

.PHONY: help build clean install uninstall
