#!/bin/sh

# https://support.google.com/a/answer/174125?hl=en
# Requires setting env variables $PROJECT, $ZONE, and $DOMAIN
# Always sets `Blank`, not `@`.

echo "Setting up GSuite Gmail MX records for Cloud DNS"

if [ -z "$PROJECT" ]
then
    echo "ERROR: \$PROJECT isn't set!"
    exit
fi

if [ -z "$ZONE" ]
then
    echo "ERROR: \$ZONE isn't set!"
    exit
fi

if [ -z "$DOMAIN" ]
then
    echo "ERROR: \$DOMAIN isn't set!"
    exit
fi

gcloud --project=$PROJECT dns record-sets transaction start -z=$ZONE
gcloud --project=$PROJECT dns record-sets transaction add -z=$ZONE  --type=MX  --name="$DOMAIN."  --ttl=3600 \
	"1 ASPMX.L.GOOGLE.COM." "5 ALT1.ASPMX.L.GOOGLE.COM." "5 ALT2.ASPMX.L.GOOGLE.COM." \
	"10 ALT3.ASPMX.L.GOOGLE.COM." "10 ALT4.ASPMX.L.GOOGLE.COM."
gcloud --project=$PROJECT dns record-sets transaction execute -z=$ZONE
