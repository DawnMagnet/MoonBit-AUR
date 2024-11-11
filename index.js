import axios from "axios";
import https from "https";
import { readFileSync, writeFileSync } from "fs";

const INFO_URL =
  "https://cli.moonbitlang.com/binaries/latest/moonbit-linux-x86_64.sha256";

async function getSHA() {
  const axiosInstance = axios.create({
    timeout: 60000,
    headers: {
      "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    },
    maxRedirects: 5,
    proxy: false,
    httpsAgent: new https.Agent({
      rejectUnauthorized: false,
      keepAlive: true,
      timeout: 60000,
    }),
  });

  let retries = 30;
  while (retries > 0) {
    try {
      console.log(`尝试第 ${31 - retries} 次请求...`);
      const info = await axiosInstance.get(INFO_URL);
      if (info?.data) {
        return info.data;
      }
    } catch (e) {
      console.log(`错误类型: ${e.name}`);
      console.log(`错误信息: ${e.message}`);
      if (e.code) console.log(`错误代码: ${e.code}`);
      if (e.response) console.log(`响应状态: ${e.response.status}`);
      --retries;
      if (retries > 0) {
        const waitTime = (31 - retries) * 100;
        console.log(`等待 ${waitTime / 1000} 秒后重试，还剩 ${retries} 次机会`);
        await new Promise((resolve) => setTimeout(resolve, waitTime));
      }
    }
  }
  throw new Error("获取SHA失败");
}

function processSHA(shaContent) {
  const shaObject = Object.fromEntries(
    shaContent
      .split("\n")
      .filter((line) => line.trim())
      .map((line) => {
        const [sha, filename] = line.trim().split(/\s+/);
        return [filename, sha];
      })
  );
  return shaObject;
}

const VSCODE_EXTENSION_URL =
  "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery";

async function getVSCodeExtensionVersion() {
  const axiosInstance = axios.create({
    timeout: 60000,
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json;api-version=7.1-preview.1",
      "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    },
  });

  const requestData = {
    filters: [
      {
        criteria: [{ filterType: 7, value: "moonbit.moonbit-lang" }],
      },
    ],
    flags: 914,
  };

  let retries = 30;
  while (retries > 0) {
    try {
      console.log(`尝试第 ${31 - retries} 次请求...`);
      const response = await axiosInstance.post(
        VSCODE_EXTENSION_URL,
        requestData
      );
      const extension = response.data.results[0]?.extensions[0];
      if (extension) {
        return extension.versions[0].version;
      }
      throw new Error("未找到插件信息");
    } catch (e) {
      console.log(`错误类型: ${e.name}`);
      console.log(`错误信息: ${e.message}`);
      if (e.code) console.log(`错误代码: ${e.code}`);
      if (e.response) console.log(`响应状态: ${e.response.status}`);
      --retries;
      if (retries > 0) {
        const waitTime = (31 - retries) * 100;
        console.log(`等待 ${waitTime / 1000} 秒后重试，还剩 ${retries} 次机会`);
        await new Promise((resolve) => setTimeout(resolve, waitTime));
      }
    }
  }
  throw new Error("获取VSCode插件版本失败");
}

const version = await getVSCodeExtensionVersion();

const version_current = readFileSync("VERSION");

// if (version == version_current) {
//     process.exit(0);
// }

const SHA = processSHA(await getSHA());

const PKGBUILD =
  `pkgname=moonbit-bin
pkgver=${version}
pkgrel=1
pkgdesc="Intelligent developer platform for Cloud and Edge using WASM"
arch=('x86_64')
url="https://www.moonbitlang.com/"
license=('unknown')
depends=('tar' 'glibc' 'gcc-libs' 'git')
provides=("moonbit")
conflicts=("moonbit")
options=('!debug')
_origin="https://cli.moonbitlang.com"
source=("https://cli.moonbitlang.cn/binaries/latest/moonbit-linux-x86_64.tar.gz"
        "https://cli.moonbitlang.cn/cores/core-latest.tar.gz"
        "moon.sh")
sha512sums=("SKIP")

` + readFileSync("PKG");

writeFileSync("VERSION", version);

writeFileSync("PKGBUILD", PKGBUILD);
