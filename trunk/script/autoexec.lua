-----------------------------------------------------------
-- NOTES: This file is run on app start after exports are done inside 
-- 		  the engine (once per context created)
-----------------------------------------------------------

-- set up path
package.path = package.path .. ";common\\?.lua"
package.path = package.path .. ";tfh\\mod\\ww1tfh\\script\\?.lua"
package.path = package.path .. ";tfh\\mod\\ww1tfh\\script\\country\\?.lua"
package.path = package.path .. ";tfh\\mod\\ww1tfh\\script\\diplomacy\\?.lua"
package.path = package.path .. ";tfh\\mod\\ww1tfh\\script\\intelligence\\?.lua"
package.path = package.path .. ";tfh\\mod\\ww1tfh\\script\\politics\\?.lua"
package.path = package.path .. ";tfh\\mod\\ww1tfh\\script\\production\\?.lua"
package.path = package.path .. ";tfh\\mod\\ww1tfh\\script\\utilities\\?.lua"
--require('hoi') -- already imported by game, contains all exported classes

-- Utilities Folder
require('utilities')
require('support_country')
require('support_functions')

-- Main Folder Files
require('country')
require('foreign_minister')
require('intelligence_minister')
require('politics_minister')
require('production_minister')
require('slider')
require('tech_minister')
require('trade')
require('globals')

-- Common Folder
require('defines')

-- Production Folder
require('buildings')
require('land')
require('air')
require('sea')
require('elite')
require('units')
require('convoy')

-- Diplomacy Folder
require('war')
require('alignment')
require('influence')
require('embargo')
require('call_ally')
require('nap')
require('allow_debt')
require('invite_faction')
require('guarantee')
require('military_access')
require('alliance')
require('lend_lease')
require('license')
require('peace')
require('exp_forces')

-- Politics Folder
require('mobilization')
require('liberation')
require('puppet')
require('change_ministers')
require('laws')

-- Intelligence Folder
require('abroad')
require('home')

-- Default Files
require('DEFAULT_GIE')
require('DEFAULT_PUP')
require('DEFAULT_LAND')
require('DEFAULT_MIXED')

-- load country specific AI modules.
-- Majors
require('GER')
require('AUH')
require('TUR')
require('RUS')
require('ENG')
require('FRA')
require('ITA')
require('SPR')
require('SCH')
require('DEN')
require('BUL')
require('JAP')
require('ROM')
require('SER')
require('USA')
require('GRE')
require('POR')
require('HOL')
require('HJZ')
require('ASR')
require('YEM')