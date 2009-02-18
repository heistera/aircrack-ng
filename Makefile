#!/usr/bin/make
# ID's
UID="root"
GID="root"

# This is ok for local installs but change it for packaging... on some systems it hasn't got to be changed for packaging :-)


# Dirs
PREF="/usr/local"
BINMODE="755"
SBINDIR=$(DESTDIR)$(PREF)"/sbin"
ETCDIR=$(DESTDIR)"/etc"
SHAREDIR=$(DESTDIR)$(PREF)"/share/airoscript"
LOCALEDIR=$(DESTDIR)$(PREF)"/share/locale/"
MANDIR=$(DESTDIR)$(PREF)"/share/man/man1"
DOCDIR=$(DESTDIR)$(PREF)"/share/doc/airoscript"

install: airopdate
	@echo -en "Installing files into:$(BINDIR) $(ETCDIR) $(SHAREDIR) $(DOCDIR) $(SBINDIR) "
	@install -D -o $(UID) -g $(GID) -m $(BINMODE) $(CURDIR)/src/airoscript.sh          $(SBINDIR)/airoscript
	@mkdir -p $(SHAREDIR)/themes
	@cp -r $(CURDIR)/src/themes/*					                   $(SHAREDIR)/themes/
	@chown $(UID):$(GID) $(SHAREDIR)/themes/*
	@chmod $(BINMODE) $(SHAREDIR)/themes/*.theme
	@install -D -o $(UID) -g $(GID) -m $(BINMODE) $(CURDIR)/src/airoscript.conf        $(ETCDIR)/airoscript.conf
	@install    -o $(UID) -g $(GID) -m $(BINMODE) $(CURDIR)/src/airopdate.sh           $(SHAREDIR)/airopdate
	@install    -o $(UID) -g $(GID) -m $(BINMODE) $(CURDIR)/src/airoscfunc.sh          $(SHAREDIR)/airoscfunc.sh
	@install    -o $(UID) -g $(GID) -m $(BINMODE) $(CURDIR)/src/airoscfunc_screen.sh   $(SHAREDIR)/airoscfunc_screen.sh
	@install    -o $(UID) -g $(GID) -m $(BINMODE) $(CURDIR)/src/airoscfunc_external.sh $(SHAREDIR)/airoscfunc_external.sh
	@install    -o $(UID) -g $(GID) -m $(BINMODE) $(CURDIR)/src/airoscfunc_unstable.sh $(SHAREDIR)/airoscfunc_unstable.sh
	@install    -o $(UID) -g $(GID) -m 644        $(CURDIR)/src/screenrc               $(SHAREDIR)/screenrc
	@echo -en "...done\nInstalling locale (spanish) on $(LOCALEDIR)"
	@mkdir -p $(LOCALEDIR)/es/LC_MESSAGES/
	@msgfmt -o $(LOCALEDIR)/es/LC_MESSAGES/airoscript.mo $(CURDIR)/src/i10n/po/es_ES
	@echo -en "...done\nInstalling manpage"
	@install -D -g $(UID) -o $(GID) -m 644	      $(CURDIR)/src/airoscript.1	   $(MANDIR)/airoscript.1
	@gzip -f -9 $(MANDIR)/airoscript.1
	@echo -en "...done\nInstalling documentation"	
	@mkdir -p $(DOCDIR)
	@cp -r $(CURDIR)/doc/* $(DOCDIR)
	@echo -en "...done\n"

airopdate:
	@install -D -o $(UID) -g $(GID) -m $(BINMODE) $(CURDIR)/src/airopdate.sh $(SBINDIR)/airopdate
	
uninstall: uninstall-airopdate
	@echo "Uninstalling airoscript."
	@rm  $(SBINDIR)/airoscript
	@rm -r $(SHAREDIR)
	@rm -r $(DOCDIR)
	@rm $(ETCDIR)/airoscript.conf
	@rm $(LOCALEDIR)/es/LC_MESSAGES/airoscript.mo
	-rm $(MANDIR)/airoscript.1.gz
	-rm $(MANDIR)/airoscript.1

uninstall-airopdate:
	@rm $(SBINDIR)/airopdate

slackware: install
	@echo "Applying wifi(way/slax) patch"
	@patch $(DESTDIR)/etc/airoscript.conf $(CURDIR)/src/patches/wifislax.conf.patch

debian: install
	@echo "Applying debian config patch (asuming your aircrack-ng is from debian packaging, if not, don't call make debian, just call make"
	@patch $(DESTDIR)/etc/airoscript.conf $(CURDIR)/src/patches/debian.conf.patch

all: install 

.PHONY: all install uninstall wifiway wifislax debian-package
