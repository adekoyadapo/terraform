#!/bin/bash

until ssh ansible@$1; do
    sleep 5
done

