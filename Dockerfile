FROM minio/minio:RELEASE.2018-06-09T03-43-35Z

COPY entrypoint.sh /opt/usr/

ENTRYPOINT ["/opt/usr/entrypoint.sh"]
