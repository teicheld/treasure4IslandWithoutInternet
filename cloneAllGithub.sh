mkdir $1 
cd $1
pwd
curl -s https://api.github.com/orgs/$1/repos | grep \"clone_url\" | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | xargs -n1 git clone
