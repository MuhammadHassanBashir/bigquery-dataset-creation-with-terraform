#!/bin/bash
BRANCH="variables"
# wb-frontend
echo "wb-frontend"
echo "Step 1: Cloning Repositories"
gh repo clone Aretec-Inc/wb-frontend -- --branch $BRANCH
gh repo clone Aretec-Inc/wb-citations -- --branch $BRANCH
gh repo clone Aretec-Inc/wb-search -- --branch $BRANCH
gh repo clone Aretec-Inc/wb-converse -- --branch main

echo "1: Installing Required Dependencies"
cd ./wb-frontend/client
yarn

echo "2: Generating Production Optimized Build"
yarn run build

echo "3: Removing Node Modules"
rm -rf node_modules
cd ..

echo "4: Archieving..."
zip -r wb-frontend.zip ./*
echo "Archieve Created: wb-frontend.zip"

echo "5: Copying the Zip to the Root Directory"
mv wb-frontend.zip ../
cd ..

echo "wb-citations"
echo "Archieving"
cd wb-citations
zip -r wb-citations.zip ./
mv wb-citations.zip ../
cd ..

echo "wb-search"
echo "Archieving"
cd wb-search
zip -r wb-search.zip ./
mv wb-search.zip ../
cd ..

echo "wb-converse"
echo "Archieving"
cd wb-converse
zip -r wb-converse.zip ./
mv wb-converse.zip ../
cd ..

echo "Step 6: Initializing Terraform"
terraform init

echo "Step 7: Planning the Infrastructure"
terraform plan

echo "Step 8: Applying Terraform Script"
terraform apply -auto-approve

echo "Cleaning Directories"
rm -rf wb-frontend
rm -rf wb-citations
rm -rf wb-search
rm -rf wb-converse
rm wb-frontend.zip
rm wb-citations.zip
rm wb-search.zip
rm wb-converse.zip
