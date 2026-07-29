#!/bin/sh
mon=$(mmsg get cursorpos | jq -r .monitor)
mmsg dispatch "viewcrossmon,$1,$mon"
