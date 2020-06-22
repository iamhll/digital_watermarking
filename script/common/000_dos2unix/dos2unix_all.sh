
all_typ="c
         m
         pl
         sh
         v
         vh
         f
         lst
         mk
         prj
         sgdc
         tcl
        "
all_dir="doc
         script
         src
         yuv
        "

for cur_typ in $all_typ
do
  for cur_dir in $all_dir
  do
    find "../$cur_dir" -name "*.$cur_typ"    \
      | xargs dos2unix >& /dev/null
  done
done
