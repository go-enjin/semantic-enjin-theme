// Copyright (c) 2022  The Go-Enjin Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package theme

import (
	"embed"

	"github.com/go-enjin/be/pkg/log"
	"github.com/go-enjin/be/pkg/theme"
)

//go:embed semantic-enjin/**
//go:embed semantic-enjin/layouts/_default/**
var semanticEnjinThemeFS embed.FS

var semanticEnjinThemeInstance *theme.Theme = nil

func SemanticEnjinTheme() *theme.Theme {
	if semanticEnjinThemeInstance != nil {
		return semanticEnjinThemeInstance
	}
	if dt, err := theme.NewEmbed("semantic-enjin", semanticEnjinThemeFS); err != nil {
		log.FatalF("error loading semantic-enjin theme: %v", err)
	} else {
		log.DebugF("included semantic-enjin theme")
		semanticEnjinThemeInstance = dt
		return dt
	}
	return nil
}