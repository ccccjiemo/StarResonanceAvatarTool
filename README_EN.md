## 🔄 Texture Data Update Instructions

This tool fetches texture configuration files from the domestic Gitee repository by default. If your network environment cannot access Gitee, follow these steps to switch to the GitHub source:
1. Open setting.json
2. Completely delete the line "config_repository_url": "https://gitee.com/..." (⚠️ Ensure there are no trailing commas left after deletion to maintain valid JSON syntax)
3. Save the file and restart the tool; the program will automatically fall back to the GitHub repository

💡 Tip: After modification, we recommend validating the JSON syntax with an online tool (e.g., jsonlint.com) to prevent configuration errors that could stop the tool from launching.

## 📁 File Documentation
For texture path mapping, naming conventions, and supported formats, please refer to [Configuration File Guide](configs/README_EN.md).

## ⚠️ Disclaimer
- Usage Risk: This tool modifies local game files, which may cause game crashes, save file corruption, update failures, or account penalties. Using it in online multiplayer games is highly likely to trigger anti-cheat systems and result in permanent bans.
- Unofficial Project: This project is not affiliated with, endorsed by, or authorized by the game developer/publisher. Use of this tool may violate the game's End User License Agreement (EULA) or Terms of Service. Users assume all legal and account-related risks.
- Legitimate Use: This project is intended solely for personal learning, technical research, or non-commercial purposes. Commercial use, redistribution, or any activity that undermines game fairness is strictly prohibited.
- No Warranty: The author provides no express or implied warranties regarding the tool's availability, security, compatibility, or fitness for any particular purpose.
- Copyright Contact: If any content in this project infringes upon your copyright, please contact the author. We will promptly investigate and take appropriate action upon verification.
