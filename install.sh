term_width=$(tput cols)
total_steps=11
current_step=1
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

run_command "pacman -S --needed git base-devel &>/dev/null && git clone https://aur.archlinux.org/yay.git &>/dev/null && cd yay && makepkg -si &>/dev/null" "Installing YAY"
run_command "yay -S leftwm wezterm eww neofetch rofi ttf-joypixels picom-ibhagwan-git" "Installing AUR Package ttf-joypixels"
run_command "curl -LJO https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/VictorMono.zip &> /dev/null && unzip VictorMono.zip -d ~/.local/share/fonts &> /dev/null && fc-cache -f" "Installing VictorMono"
run_command "git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim" "Cloning Packer"
run_command "cp ~/arch-bootstrap/config/ ~/.config/" "Creating .config directory"
run_command "git clone --depth 1 https://github.com/adamkali/FishConfig.git &>/dev/null && cp ./FishConfig/config.fish ~/.config/fish" "Cloning FishConfig"
run_command "pip install pyright" "Installing pyright"
run_command "go install golang.org/x/tools/gopls@latest" "Installing golang-lsp"
run_command "cargo install texlab" "Installing Texlab"
run_command "npm install -g typescript typescript-language-server svelte-language-server @tailwindcss/language-server" "Installing npm packages for language servers"
run_command "rm -rf ./FishConfig &>/dev/null && rm -rf ./arch-bootstrap &>/dev/null" "cleaning up"

echo -e "\n\033[0;32mAdam's Bootstrap completed successfully\033[0m"

