TMPFN=db2pstmp$$

if [ $# -gt 2 ]
then
  echo "Usage: `basename $0` [filename.sgml]" >&2
  exit 1
fi

output="`echo $1 | sed 's,\.sgml$,.ps,;s,\.sgm$,.ps,'`"
outdvi="`echo $1 | sed 's,\.sgml$,.dvi,;s,\.sgm$,.dvi,'`"
db2dvi "$@"
dvips $outdvi -o $output

# SUP: What's this stuff below???
exit 0

if [ $# -eq 1 ]
then
  if [ ! -r $1 ]
  then
    echo Cannot read \"$1\".  Exiting. >&2
    exit 1
  fi
  if echo $1 | egrep -i '\.sgml$|\.sgm$' >/dev/null 2>&1
  then
    output="`echo $1 | sed 's,\.sgml$,.ps,;s,\.sgm$,.ps,'`"
    outdvi="`echo $1 | sed 's,\.sgml$,.dvi,;s,\.sgm$,.dvi,'`"
    # if we have a filename argument let us improve the
    # temporary filename, sine gv and ghostview will display it.
    # this TMPFN has $1 embedded in it
    TMPFN=`echo $1 | sed 's/\.sgml//'`_db2pstmp$$
  fi
fi

db2dvi "$@"

if [ ! -f ${TMPFN}.dvi ]
then
  exit 1
fi

dvips $outdvi -o $output

if [ -f ${TMPFN}.ps ]
then
  if [ $# -eq 1 ]
  then
    if [ -n "$output" ]
    then
      mv ${TMPFN}.ps $output
    else
      mv ${TMPFN}.ps db2ps.ps
    fi
  else
    cat ${TMPFN}.ps
  fi
fi

rm -f ${TMPFN}*

exit 0
