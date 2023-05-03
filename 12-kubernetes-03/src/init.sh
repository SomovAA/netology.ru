#curl -s nginx-svc:80; if test "$?" = "6"; then exit 1; else exit 0; fi
# until sh init.sh; do echo waiting for nginx-svc; sleep 3; done
# until (curl -s nginx-svc:80; if test '$?' = '6'; then exit 1; else exit 0; fi); do echo waiting for nginx-svc; sleep 3; done
# until (curl -s http://example.com; if test '$?' = '6'; then exit 1; else exit 0; fi); do echo waiting for nginx-svc; sleep 3; done
# until [curl -s http://example.com; if test '$?' = '6'; then exit 1; else exit 0; fi]; do echo waiting for nginx-svc; sleep 3; done
#curl -s http://example.com; if test "$?" = "6"; then exit 1; else exit 0; fi

while true
do
   curl -s nginx-svc:80;
   res=$?

   if test "$res" = "7"; then
     exit 0;
   fi

   if test "$res" = "0"; then
     exit 0;
   fi

   echo "waiting for nginx-svc"
   sleep 3
done