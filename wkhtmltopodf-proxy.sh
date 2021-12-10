#!/usr/bin/env sh
PARAMS="$@";
shift $#;
curl "${WKHTMLTOPDF_SERVICE_URL:-http://127.0.0.1:9800}" -d "params=$PARAMS" --output -