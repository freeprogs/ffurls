
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


# Install section

home_dir = /home/guest
path_python_script = /usr/local/bin
path_shell_scripts = $(home_dir)/.env/scripts

PYTHON_SCRIPT_DIR = $(path_python_script)
SHELL_SCRIPTS_DIR = $(path_shell_scripts)


# Commands

help:
	@echo "usage: make [ clean | install | uninstall ]" 1>&2

clean:
	@rm -f $(TEST_OUTPUT_FILES) && echo "$(PROG) cleaned"

install:
	install -d $(PYTHON_SCRIPT_DIR)
	install $(TARGET_PYTHON_SCRIPT) $(PYTHON_SCRIPT_DIR)/$(TARGET_PYTHON_SCRIPT)
	install -d $(SHELL_SCRIPTS_DIR)
	install $(TARGET_SHELL_SCRIPT_GENERAL) $(SHELL_SCRIPTS_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_GENERAL)
	install $(TARGET_SHELL_SCRIPT_TEXT) $(SHELL_SCRIPTS_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_TEXT)
	install $(TARGET_SHELL_SCRIPT_HTML) $(SHELL_SCRIPTS_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_HTML)
	install $(TARGET_SHELL_SCRIPT_ORG) $(SHELL_SCRIPTS_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_ORG)

uninstall:
	rm -f $(PYTHON_SCRIPT_DIR)/$(TARGET_PYTHON_SCRIPT)
	rm -f $(SHELL_SCRIPTS_DIR)/$(TARGET_SHELL_SCRIPT_GENERAL)
	rm -f $(SHELL_SCRIPTS_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_TEXT)
	rm -f $(SHELL_SCRIPTS_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_HTML)
	rm -f $(SHELL_SCRIPTS_DIR)/$(TARGET_RENAMED_SHELL_SCRIPT_ORG)

.PHONY: help clean install uninstall
