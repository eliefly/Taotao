package com.taotao.common.pojo;

/**
 * 图片上传结果
 *
 * @author eliefly
 * @create 2018-01-06 22:04
 */
public class PicUploadResult {

    /**
     * 0上传成功，1代表上传失败
     */
    private Integer error;

    private String width;

    private String height;

    private String url;

    public Integer getError() {
        return error;
    }

    public void setError(Integer error) {
        this.error = error;
    }

    public String getWidth() {
        return width;
    }

    public void setWidth(String width) {
        this.width = width;
    }

    public String getHeight() {
        return height;
    }

    public void setHeight(String height) {
        this.height = height;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

}
