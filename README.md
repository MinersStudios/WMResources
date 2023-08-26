<div align="center">
  <h1>
    <a href="https://minersstudios.com">
      <img alt="MinersStudios" src="https://raw.githubusercontent.com/MinersStudios/.github/main/assets/logos/logo_ua.svg" width="128" />
    </a>
    <br>
    Miners Studios
    <br><br>
    <div>
      <a href="https://github.com/MinersStudios/MSTextures/stargazers">
        <img alt="Stars" src="https://img.shields.io/github/stars/MinersStudios/MSTextures?style=for-the-badge&color=FFF2CC&labelColor=302D41" />
      </a>
      <a href="https://github.com/MinersStudios/MSTextures/contributors">
        <img alt="Contributors" src="https://img.shields.io/github/contributors/MinersStudios/MSTextures?style=for-the-badge&color=d5c3f0&labelColor=302D41" />
      </a>
      <a href="#">
        <img alt="GitHub code size in bytes" src="https://staging.shields.io/github/languages/code-size/MinersStudios/MSTextures?style=for-the-badge&color=a6da95&labelColor=302D41" />
      </a>
      <br>
      <a href="https://whomine.net/discord">
        <img alt="WhoMine Discord" src="https://img.shields.io/discord/928575868643733535?style=for-the-badge&label=WhoMine&logo=discord&color=C9CBFF&logoColor=d9e0ee&labelColor=302d41" />
      </a>
      <a href="https://whomine.net/telegram">
        <img alt="Telegram" src="https://img.shields.io/badge/telegram-black?logo=Telegram&style=for-the-badge&color=C9CBFF&logoColor=d9e0ee&labelColor=302d41" />
      </a>
    </div>
    <br>
  </h1>
  <br>

  <p>
    A Minecraft texture pack for server WhoMine<br>
    (Project is in development, so there is shit)
  </p>
  
  <br>

  <h1>Versions of the resource pack</h1>
  <p>
    <ul align="left">
      <li><b><code> Full </code></b> : Includes all resource pack files that are specified in <i>white_list.txt</i></li>
      <li><b><code> Lite </code></b> : Includes all resource pack files specified in <i>"white_list.txt"</i> except those specified in <i>"lite_black_list.txt"</i>.
                            This version does not include any decorative additions that do not affect custom <b>blocks / items / decoration</b>, such as : <br>
                            <i>different icons, animated items, modified block models</i>
      </li>
    </ul>
  </p>

  <br>

  <h1>Zipper Script</h1>
  <p>
    This script is designed to compress JSON files in a specific directory structure and create two different archive files: <br>
    Full and Lite versions
  </p>
  <div align="left">
    <br>
    <h2>Prerequisites</h2>
    <p>
      Before using this script, ensure that you have the following files in the same directory as the script :
      <ul>
        <li><code>pack.mcmeta</code> : This file should contain information about the Minecraft resource pack, including its version</li>
        <li><code>white_list.txt</code> : A list of file paths that you want to include in both archives</li>
        <li><code>lite_black_list.txt</code> : A list of paths that you want to exclude from the <code><i>Lite</i></code> archive</li>
      </ul>
    </p>
    <br>
    <h2>Usage</h2>
    <ol>
        <li>Make sure all the required files are present in the script's directory</li>
        <li>Open a terminal or command prompt</li>
        <li>Navigate to the script's directory using the <code>cd</code> command</li>
        <li>
          Run the script by executing the following command:
          <pre><code>python zipper.py</code></pre>
        </li>
    </ol>
    <br>
    <h2>Output</h2>
    <p>After running the script, you'll find two archive files in the same directory as the script :</p>
    <ul>
        <li><code>FULL_WMTextures-v(VERSION).zip</code> : Full version archive which includes all resource pack files specified in <i>"white_list.txt"</i></li>
        <li><code>LITE_WMTextures-v(VERSION).zip</code> : A lite version archive that Includes all resource pack files specified in <i>"white_list.txt"</i> except those specified in <i>"lite_black_list.txt"</i></li>
    </ul>
    <br>
    <p>
      <i>For any questions or issues related to the script, feel free to open an issue on the repository.
    </p>
  </div>
    
  <h1></h1>

  <a rel="license" target="_blank" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">
    <img alt="Лицензия Creative Commons" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" />
  </a>
  <h6>
    This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>
    <br><br>
    <li>Feel free to include this resource pack in your server, mod pack, etc.</li>
    <li>If you wish to use this pack in any form of content, please credit with a link to the original GitHub page where you can</li>
  </h6>
</div>
