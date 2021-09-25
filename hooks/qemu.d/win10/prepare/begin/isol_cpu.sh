#!/bin/bash

systemctl set-property --runtime -- user.slice AllowedCPUs=5,11
systemctl set-property --runtime -- system.slice AllowedCPUs=5,11
systemctl set-property --runtime -- init.scope AllowedCPUs=5,11
