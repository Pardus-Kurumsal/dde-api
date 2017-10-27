/**
 * Copyright (C) 2014 Deepin Technology Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 **/

package lang_info

import (
	. "github.com/smartystreets/goconvey/convey"
	"testing"
)

func TestSupportedLocale(t *testing.T) {
	Convey("Test locale whether supported", t, func() {
		list, err := getSupportedLocaleList("testdata/SUPPORTED")
		So(err, ShouldEqual, nil)
		So(len(list), ShouldEqual, 475)

		So(isItemInList("zh_CN.UTF-8", list), ShouldEqual, true)
		So(isItemInList("zh_CNN.UTF-8", list), ShouldEqual, false)
	})
}

func TestLangInfo(t *testing.T) {
	Convey("Test language info", t, func() {
		infos, err := getLangInfosFromFile("testdata/language_info.json")
		So(err, ShouldEqual, nil)
		So(len(infos), ShouldEqual, 143)
		_, err = infos.Get("zh_CNN")
		So(err, ShouldNotEqual, nil)

		info, err := getLangInfoByLocale("zh_CN.UTF-8",
			"testdata/language_info.json")
		So(err, ShouldEqual, nil)
		So(info.LangCode, ShouldEqual, "zh-hans")
		So(info.ToLangCode().CountryCode, ShouldEqual, "CN")
	})
}
