#!/bin/bash

hugo

git add ../*
git commit -m "auto deploy"
git push
