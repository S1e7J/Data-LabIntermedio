for archivo in *.csv; do
  echo "===== $archivo =====" >>$1
  cat $archivo >>$1
  echo "" >>$1
done
