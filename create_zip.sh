ZIPFILE="../$( grep "^id=" module.prop | cut -f2 -d "=" )_$( grep "^version=" module.prop | cut -f2 -d "=" ).zip" 
echo ""
echo "*** Creating the ZIP file \"${ZIPFILE}\" ..."
[ -r "${ZIPFILE}" ] && \rm -r "${ZIPFILE}"
zip -y -r "${ZIPFILE}" .

echo ""
ls -l "${ZIPFILE}"
