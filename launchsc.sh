#!/bin/bash

if ! pgrep -f SierraChart_64.exe >/dev/null; then
  wine /home/one/.wine/drive_c/SierraChart/SierraChart_64.exe &
fi
