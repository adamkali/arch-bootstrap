term_width=$(tput cols)
total_steps=12
current_step=0
step_width=$((term_width / total_steps))
fill_char="#"
empty_char=" "
arrow=">"

function show_progress() {
  local step_message=$1
  local step_progress=$((current_step * step_width))
  local filled_progress=$(printf "%0.s${fill_char}" $(seq 1 $step_progress))
  local empty_progress=$(printf "%0.s${empty_char}" $(seq 1 $((term_width - step_width * current_step - 1))))

  echo -ne "\033[2K\033[0GAdam's Arch Linux Zoomer Bootstrap: ${step_message}...\n[${filled_progress}${arrow}${empty_progress}] $((100 * current_step / total_steps))%"
}

function run_command() {
  cd ~
  local command=$1
  local step_message=$2
  show_progress "${step_message}"
  $command &>/dev/null
  local exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo -e "\n\033[0;31mError: Failed to execute '$command' with exit code $exit_code\033[0m"
    exit $exit_code
  fi
  current_step=$((current_step + 1))
}

sudo pacman -Syyuu --noconfirm 
clear
sudo pacman -S feh --noconfirm
clear
sudo pacman -S --needed git base-devel
clear
git clone https://aur.archlinux.org/yay.git 
clear
cd yay && makepkg -si && cd ../ && rm -rf yay
clear
yay -S leftwm wezterm eww neofetch rofi ttf-joypixels picom-ibhagwan-git leftwm-theme-git python-pip
clear
curl -LJO https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/VictorMono.zip && unzip VictorMono.zip -d ~/.local/share/fonts  && fc-cache -f
clear
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim 
clear
cp ~/arch-bootstrap/config/ ~/.config/ 
clear
cp /etc/X11/xinit/xinitrc ~/.xinitrc
clear
echo "exec leftwm >> ~/.xinitrc"
clear
echo -ne "
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then \n
  exec startx \n
fi
"
clear
pip install pyright
clear
go install golang.org/x/tools/gopls@latest
clear
cargo install texlab
clear
npm install -g typescript typescript-language-server svelte-language-server @tailwindcss/language-server
clear
rm -rf ~/arch-bootstrap &>/dev/null 

echo -e "\n\033[0;32mAdam's Bootstrap completed successfully\033[0m"

