#!/bin/bash
echo "Hello"

sudo mkdir -p /opt/dfir/{git,windows,custom}
sudo chown -R $USER:$USER /opt/dfir

git="/opt/dfir/git"
win="/opt/dfir/windows"
custom="/opt/dfir/custom"
bin="/usr/local/bin"

sudo apt update && sudo apt upgrade -y

sudo apt install -y \
    git curl wget unzip apt-transport-https software-properties-common\
    python3 python3-pip python3-venv \
    pipx \
    build-essential \
    libesedb-utils libpff-dev pff-tools libvshadow-utils liblnk-utils \
    wine \
    stegseek  steghide \
    testdisk \
    sqlite3 \
    npm \
    forensics-all wireshark \

source /etc/os-release
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt update && sudo apt install -y powershell

source ~/.bashrc

pipx ensurepath
source ~/.bashrc

pipx install git+https://github.com/PoorBillionaire/Windows-Prefetch-Parser.git
pipx install git+https://github.com/PoorBillionaire/USN-Record-Carver.git
pipx install git+https://github.com/PoorBillionaire/USN-Journal-Parser.git
pipx install git+https://github.com/dkovar/analyzeMFT.git
pipx install git+https://github.com/digitalsleuth/time_decode.git
pipx install git+https://github.com/williballenthin/python-evtx.git
pipx install git+https://github.com/AtesComp/Vinetto.git
pipx install git+https://github.com/volatilityfoundation/volatility3.git
pipx install git+https://github.com/williballenthin/INDXParse.git
sudo npm install -g imgclip

git clone https://github.com/inflex/undark.git $git/undark
cd $git/undark && make && cd -

git clone https://github.com/jschicht/LogFileParser.git $git/LogFileParser
git clone https://github.com/jschicht/UsnJrnl2Csv.git $git/UsnJrnl2Csv
git clone https://github.com/jschicht/ExtractUsnJrnl.git $git/ExtractUsnJrnl

wget -P $win https://download.ericzimmermanstools.com/Get-ZimmermanTools.zip
unzip -d $win $win/Get-ZimmermanTools.zip

cd $win && pwsh $win/Get-ZimmermanTools.ps1 && cd -

wget https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-win-x64.exe

wine dotnet-runtime-9.0.14-win-x64.exe
rm dotnet-runtime-9.0.14-win-x64.exe

echo "[*] Creating Wine wrappers for Windows tools..."

find "$win" -type f -iname "*.exe" | while read -r exe; do
	name=$(basename "$exe" .exe)
	cmd_name=$(echo "$name" | tr '[:upper:]' '[:lower:]')
	wrapper_path="$bin/$cmd_name"

	if [ -f "$wrapper_path" ]; then
		echo "[-] Skipping existing wrapper: $cmd_name"
		continue
	fi

	echo "[+] Creating wrapper: $cmd_name"
	sudo tee "$wrapper_path" > /dev/null <<EOF
#!/bin/bash
wine "$exe" "\$@"
EOF
	sudo chmod +x "$wrapper_path"

done

echo "[*] Wrapper creation complete"
echo "Done"

