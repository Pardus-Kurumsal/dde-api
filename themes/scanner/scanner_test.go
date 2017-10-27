/**
 * Copyright (C) 2014 Deepin Technology Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 **/

package scanner

import (
	. "github.com/smartystreets/goconvey/convey"
	"sort"
	"testing"
)

func TestListGtkTheme(t *testing.T) {
	Convey("List gtk theme", t, func() {
		list, err := ListGtkTheme("testdata/Themes")
		sort.Strings(list)
		So(list, ShouldResemble, []string{
			"testdata/Themes/Gtk1",
			"testdata/Themes/Gtk2"})
		So(err, ShouldBeNil)
	})
}

func TestListIconTheme(t *testing.T) {
	Convey("List icon theme", t, func() {
		list, err := ListIconTheme("testdata/Icons")
		sort.Strings(list)
		So(list, ShouldResemble, []string{
			"testdata/Icons/Icon1",
			"testdata/Icons/Icon2"})
		So(err, ShouldBeNil)
	})
}

func TestListCursorTheme(t *testing.T) {
	Convey("List cursor theme", t, func() {
		list, err := ListCursorTheme("testdata/Icons")
		sort.Strings(list)
		So(list, ShouldResemble, []string{
			"testdata/Icons/Icon1",
			"testdata/Icons/Icon2"})
		So(err, ShouldBeNil)
	})
}

func TestThemeHidden(t *testing.T) {
	Convey("Test theme is hidden", t, func() {
		So(isHidden("testdata/gtk_paper.theme", ThemeTypeGtk),
			ShouldEqual, false)
		So(isHidden("testdata/gtk_paper_hidden.theme", ThemeTypeGtk),
			ShouldEqual, true)

		So(isHidden("testdata/icon_deepin.theme", ThemeTypeIcon),
			ShouldEqual, false)
		So(isHidden("testdata/icon_deepin_hidden.theme", ThemeTypeIcon),
			ShouldEqual, true)
	})
}
