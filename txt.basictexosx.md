# A Smaller Distribution, BasicTeX

Quoting from the official [page](https://www.tug.org/mactex/morepackages.html)[0] or the official [documentation](http://pages.uoregon.edu/koch/BasicTeX.pdf)[1].

BasicTeX is a much smaller alternate TeX Distribution for users who do not want to download the full TeX Live. BasicTeX is a subset of TeX Live of size 100 megabytes instead of 2 gigabytes. BasicTeX does not overwrite the full distribution; it is installed in `/usr/local/texlive/2015basic`.
To use TeX on the Mac, it suffices to install BasicTeX and a front end. To make life easier for users who want to use BasicTeX instead of the full TeX Live, we include links below to various pieces of MacTeX that can be added as needed.

BasicTeX was designed for easy download by users with limited download speed. The package is remarkably capable. It contains all of the standard tools needed to write TeX documents, including TeX, LaTeX, pdfTeX, MetaFont, dvips, MetaPost, and XeTeX. It contains AMSTeX, the Latin Modern Fonts, the TeX Live Manager to add and update packages from TeX Live, and the new SyncTeX.

- [0] https://www.tug.org/mactex/morepackages.html
- [1] http://pages.uoregon.edu/koch/BasicTeX.pdf

```
$ brew cask install basictex
$ brew cask info basictex

basictex: latest
BasicTeX
https://www.tug.org/mactex/morepackages.html
/opt/homebrew-cask/Caskroom/basictex/latest (107M)
https://github.com/caskroom/homebrew-cask/blob/master/Casks/basictex.rb
==> Contents
  BasicTeX.pkg (pkg)
```

## TLMGR - the TeX Linve (package-ish) Manager

```
$ /Library/TeX/texbin/tlmgr help

TLMGR(1)              User Contributed Perl Documentation             TLMGR(1)

NAME
       tlmgr - the TeX Live Manager

SYNOPSIS
       tlmgr [option]... action [option]... [operand]...

DESCRIPTION
       tlmgr manages an existing TeX Live installation, both packages and
       configuration options.  For information on initially downloading and
       installing TeX Live, see <http://tug.org/texlive/acquire.html>.

       The most up-to-date version of this documentation (updated nightly from
       the development sources) is available at
       <http://tug.org/texlive/tlmgr.html>, along with procedures for updating
       "tlmgr" itself and information about test versions.

       TeX Live is organized into a few top-level schemes, each of which is
       specified as a different set of collections and packages, where a
       collection is a set of packages, and a package is what contains actual
       files.  Schemes typically contain a mix of collections and packages,
       but each package is included in exactly one collection, no more and no
       less.  A TeX Live installation can be customized and managed at any
       level.

       See <http://tug.org/texlive/doc> for all the TeX Live documentation
       available.
```

### TLMGR - info
```
$ /Library/TeX/texbin/tlmgr info

TeX Live 2015 is frozen forever and will no
longer be updated.  This happens in preparation for a new release.

If you're interested in helping to pretest the new release (when
pretests are available), please read http://tug.org/texlive/pretest.html.
Otherwise, just wait, and the new release will be ready in due time.
tlmgr: package repository http://ctan.mirror.garr.it/mirrors/CTAN/systems/texlive/tlnet

```

### TLMGR - version
```
$ /Library/TeX/texbin/tlmgr version

tlmgr revision 39298 (2016-01-07 03:44:29 +0100)
tlmgr using installation: /usr/local/texlive/2015basic
TeX Live (http://tug.org/texlive) version 2015

### TLMGR - conf
```
$ /Library/TeX/texbin/tlmgr conf
=========================== version information ==========================
tlmgr revision 39298 (2016-01-07 03:44:29 +0100)
tlmgr using installation: /usr/local/texlive/2015basic
TeX Live (http://tug.org/texlive) version 2015

==================== executables found by searching PATH =================
PATH: /Library/TeX/texbin:/Users/edoardo/.rbenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:/Users/edoardo/.rvm/bin:/Users/edoardo/Workspaces/go.sources/bin:/usr/local/opt/go/libexec/bin:/usr/local/opt/go/libexec/bin:/Users/edoardo/.fzf/bin:/Users/edoardo/.rvm/bin
kpsewhich: /Library/TeX/texbin/kpsewhich
updmap: /Library/TeX/texbin/updmap
fmtutil: /Library/TeX/texbin/fmtutil
tlmgr: /Library/TeX/texbin/tlmgr
tex: /Library/TeX/texbin/tex
pdftex: /Library/TeX/texbin/pdftex
mktexpk: /Library/TeX/texbin/mktexpk
dvips: /Library/TeX/texbin/dvips
dvipdfmx: /Library/TeX/texbin/dvipdfmx
=========================== active config files ==========================
texmf.cnf: /usr/local/texlive/2015basic/texmf.cnf
texmf.cnf: /usr/local/texlive/2015basic/texmf-dist/web2c/texmf.cnf
updmap.cfg: /usr/local/texlive/2015basic/texmf-dist/web2c/updmap.cfg
fmtutil.cnf: /usr/local/texlive/2015basic/texmf-dist/web2c/fmtutil.cnf
config.ps: /usr/local/texlive/2015basic/texmf-config/dvips/config/config.ps
mktex.cnf: /usr/local/texlive/2015basic/texmf-dist/web2c/mktex.cnf
pdftexconfig.tex: /usr/local/texlive/2015basic/texmf-config/tex/generic/config/pdftexconfig.tex
============================= font map files =============================
psfonts.map: /usr/local/texlive/2015basic/texmf-var/fonts/map/dvips/updmap/psfonts.map
pdftex.map: /usr/local/texlive/2015basic/texmf-var/fonts/map/pdftex/updmap/pdftex.map
ps2pk.map: /usr/local/texlive/2015basic/texmf-var/fonts/map/dvips/updmap/ps2pk.map
kanjix.map: /usr/local/texlive/2015basic/texmf-var/fonts/map/dvipdfmx/updmap/kanjix.map
=========================== kpathsea variables ===========================
TEXMFMAIN=/usr/local/texlive/2015basic/texmf-dist
TEXMFDIST=/usr/local/texlive/2015basic/texmf-dist
TEXMFLOCAL=/usr/local/texlive/2015basic/texmf-local
TEXMFSYSVAR=/usr/local/texlive/2015basic/texmf-var
TEXMFSYSCONFIG=/usr/local/texlive/2015basic/texmf-config
TEXMFVAR=/Users/edoardo/Library/texlive/2015basic/texmf-var
TEXMFCONFIG=/Users/edoardo/Library/texlive/2015basic/texmf-config
TEXMFHOME=/Users/edoardo/Library/texmf
VARTEXFONTS=/Users/edoardo/Library/texlive/2015basic/texmf-var/fonts
TEXMF={/Users/edoardo/Library/texlive/2015basic/texmf-config,/Users/edoardo/Library/texlive/2015basic/texmf-var,/Users/edoardo/Library/texmf,!!/usr/local/texlive/2015basic/texmf-config,!!/usr/local/texlive/2015basic/texmf-var,!!/usr/local/texlive/2015basic/texmf-local,!!/usr/local/texlive/2015basic/texmf-dist}
SYSTEXMF=/usr/local/texlive/2015basic/texmf-var:/usr/local/texlive/2015basic/texmf-local:/usr/local/texlive/2015basic/texmf-dist
TEXMFDBS={!!/usr/local/texlive/2015basic/texmf-config,!!/usr/local/texlive/2015basic/texmf-var,!!/usr/local/texlive/2015basic/texmf-local,!!/usr/local/texlive/2015basic/texmf-dist}
WEB2C={/Users/edoardo/Library/texlive/2015basic/texmf-config,/Users/edoardo/Library/texlive/2015basic/texmf-var,/Users/edoardo/Library/texmf,!!/usr/local/texlive/2015basic/texmf-config,!!/usr/local/texlive/2015basic/texmf-var,!!/usr/local/texlive/2015basic/texmf-local,!!/usr/local/texlive/2015basic/texmf-dist}/web2c
TEXPSHEADERS=.:{/Users/edoardo/Library/texlive/2015basic/texmf-config,/Users/edoardo/Library/texlive/2015basic/texmf-var,/Users/edoardo/Library/texmf,!!/usr/local/texlive/2015basic/texmf-config,!!/usr/local/texlive/2015basic/texmf-var,!!/usr/local/texlive/2015basic/texmf-local,!!/usr/local/texlive/2015basic/texmf-dist}/{dvips,fonts/{enc,type1,type42,type3}}//
TEXCONFIG={/Users/edoardo/Library/texlive/2015basic/texmf-config,/Users/edoardo/Library/texlive/2015basic/texmf-var,/Users/edoardo/Library/texmf,!!/usr/local/texlive/2015basic/texmf-config,!!/usr/local/texlive/2015basic/texmf-var,!!/usr/local/texlive/2015basic/texmf-local,!!/usr/local/texlive/2015basic/texmf-dist}/dvips//
ENCFONTS=.:{/Users/edoardo/Library/texlive/2015basic/texmf-config,/Users/edoardo/Library/texlive/2015basic/texmf-var,/Users/edoardo/Library/texmf,!!/usr/local/texlive/2015basic/texmf-config,!!/usr/local/texlive/2015basic/texmf-var,!!/usr/local/texlive/2015basic/texmf-local,!!/usr/local/texlive/2015basic/texmf-dist}/fonts/enc//
TEXFONTMAPS=.:{/Users/edoardo/Library/texlive/2015basic/texmf-config,/Users/edoardo/Library/texlive/2015basic/texmf-var,/Users/edoardo/Library/texmf,!!/usr/local/texlive/2015basic/texmf-config,!!/usr/local/texlive/2015basic/texmf-var,!!/usr/local/texlive/2015basic/texmf-local,!!/usr/local/texlive/2015basic/texmf-dist}/fonts/map/{kpsewhich,pdftex,dvips,}//
==== kpathsea variables from environment only (ok if no output here) ====
tlmgr: didn't get return value from action conf, assuming ok.
```

### TLMGR - install

```
$ /Library/TeX/texbin/tlmgr install enumitem
TeX Live 2015 is frozen forever and will no
longer be updated.  This happens in preparation for a new release.

If you're interested in helping to pretest the new release (when
pretests are available), please read http://tug.org/texlive/pretest.html.
Otherwise, just wait, and the new release will be ready in due time.
tlmgr: package repository http://ctan.mirror.garr.it/mirrors/CTAN/systems/texlive/tlnet
[1/1, ??:??/??:??] install: enumitem [12k]
tlmgr: package log updated: /usr/local/texlive/2015basic/texmf-var/web2c/tlmgr.log
running mktexlsr ...
done running mktexlsr.
```

### TLMGR - search
When you got an error like:

```
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! fontspec error: "font-not-found"
! 
! The font "latinmodern-math.otf" cannot be found.
! 
! See the fontspec documentation for further information.
! 
! For immediate help type H <return>.
!...............................................  
```

Look for the missing font `latinmodern-math.otf`:

```
$ tlmgr search --file latinmodern-math --global

TeX Live 2015 is frozen forever and will no
longer be updated.  This happens in preparation for a new release.

If you're interested in helping to pretest the new release (when
pretests are available), please read http://tug.org/texlive/pretest.html.
Otherwise, just wait, and the new release will be ready in due time.
tlmgr: package repository http://ctan.mirror.garr.it/mirrors/CTAN/systems/texlive/tlnet
lm-math:
	texmf-dist/fonts/opentype/public/lm-math/latinmodern-math.otf
```

Install the package:

```
$ /Library/TeX/texbin/tlmgr install lm-math

TeX Live 2015 is frozen forever and will no
longer be updated.  This happens in preparation for a new release.

If you're interested in helping to pretest the new release (when
pretests are available), please read http://tug.org/texlive/pretest.html.
Otherwise, just wait, and the new release will be ready in due time.
tlmgr: package repository http://ctan.mirror.garr.it/mirrors/CTAN/systems/texlive/tlnet
[1/1, ??:??/??:??] install: lm-math [369k]
tlmgr: package log updated: /usr/local/texlive/2015basic/texmf-var/web2c/tlmgr.log
running mktexlsr ...
done running mktexlsr.
```