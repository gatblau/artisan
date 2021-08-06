package object_storage

import (
	"context"
	"github.com/minio/minio-go/v7"
	"go/types"
	"io"
	"log"
	"os"
)

// Downloader file from bucket
func Downloader(useSSL bool, bucket string, filename string) (int64, bool, error) {
	s3Client := ObjectStorageProvider(useSSL)
	reader, err := s3Client.GetObject(context.Background(), bucket, filename, minio.GetObjectOptions{})
	if err != nil {
		log.Println(err)
	}
	defer reader.Close()
	localFile, err := os.Create("source/" + filename)
	if err != nil {
		log.Println(err)
	}
	defer localFile.Close()

	stat, err := reader.Stat()
	if err != nil {
		log.Println(err)
	}
	if _, err := io.CopyN(localFile, reader, stat.Size); err != nil {
		return stat.Size, false, err
	} else {
		return stat.Size, true, types.Error{}
	}
}
