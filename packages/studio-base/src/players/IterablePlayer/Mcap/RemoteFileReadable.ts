// This Source Code Form is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import BrowserHttpReader from "@foxglove/studio-base/util/BrowserHttpReader";
import CachedFilelike from "@foxglove/studio-base/util/CachedFilelike";

const CACHE_SIZE_DEFAULT = 200;

export class RemoteFileReadable {
  private remoteReader: CachedFilelike;

  public constructor(
    url: string,
    cacheConfig: {
      cacheSizeInMBytes?: number;
      cacheBlockSizeInMBytes?: number;
      closeEnoughBytesToNotStartNewConnectionInMBytes?: number;
    } = { cacheSizeInMBytes: CACHE_SIZE_DEFAULT },
  ) {
    const fileReader = new BrowserHttpReader(url);
    this.remoteReader = new CachedFilelike({
      fileReader,
      cacheSizeInBytes:
        cacheConfig.cacheSizeInMBytes != undefined
          ? 1024 * 1024 * cacheConfig.cacheSizeInMBytes
          : 1024 * 1024 * CACHE_SIZE_DEFAULT, // 200MiB default
      cacheBlockSizeInBytes:
        cacheConfig.cacheBlockSizeInMBytes != undefined
          ? 1024 * 1024 * cacheConfig.cacheBlockSizeInMBytes
          : undefined,
      closeEnoughBytesToNotStartNewConnection:
        cacheConfig.closeEnoughBytesToNotStartNewConnectionInMBytes != undefined
          ? 1024 * 1024 * cacheConfig.closeEnoughBytesToNotStartNewConnectionInMBytes
          : undefined,
    });
  }

  public async open(): Promise<void> {
    await this.remoteReader.open(); // Important that we call this first, because it might throw an error if the file can't be read.
  }

  public async size(): Promise<bigint> {
    return BigInt(this.remoteReader.size());
  }
  public async read(offset: bigint, size: bigint): Promise<Uint8Array> {
    if (offset + size > Number.MAX_SAFE_INTEGER) {
      throw new Error(`Read too large: offset ${offset}, size ${size}`);
    }
    return await this.remoteReader.read(Number(offset), Number(size));
  }
}
