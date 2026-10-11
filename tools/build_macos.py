"""Yerel universal macOS test paketi. Resmî export template gerektirmez.
Godot editör çalıştırıcısı pakete eklenir; App Store/noter onaylı yayın değildir.
"""
from pathlib import Path
import plistlib, shutil, subprocess
from PIL import Image
root=Path(__file__).resolve().parents[1]
engine=Path('/Users/mytkn/Downloads/Godot.app/Contents/MacOS/Godot')
subprocess.run([str(engine),'--headless','--path',str(root),'--script','tools/export_licenses.gd','--log-file','/tmp/parlak-license.log'],check=True)
subprocess.run([str(engine),'--headless','--path',str(root),'--export-pack','macOS',str(root/'builds/ParlakIsler.pck'),'--log-file','/tmp/parlak-export.log'],check=True)
app=root/'builds/Parlak Isler.app'
mac=app/'Contents/MacOS';res=app/'Contents/Resources'
mac.mkdir(parents=True,exist_ok=True);res.mkdir(parents=True,exist_ok=True)
shutil.copy2(engine,mac/'GodotRuntime')
shutil.copy2(root/'builds/ParlakIsler.pck',res/'ParlakIsler.pck')
shutil.copy2(root/'builds/GODOT-LICENSES.txt',res/'GODOT-LICENSES.txt')
shutil.copy2(root/'assets/manifest.json',res/'ASSET-SOURCES.json')
if (root/'RELEASE_NOTES.md').exists():shutil.copy2(root/'RELEASE_NOTES.md',res/'SURUM-NOTLARI.txt')
subprocess.run(['clang','-arch','arm64','-arch','x86_64','-O2',str(root/'tools/macos_launcher.c'),'-o',str(mac/'ParlakIsler')],check=True)
icons=root/'builds/ParlakIsler.iconset';icons.mkdir(exist_ok=True)
source=Image.open(root/'assets/art/crow_1.png')
for size in [16,32,128,256,512]:
 for scale in [1,2]:
  px=size*scale
  icon=Image.new('RGBA',(px,px),'#233044')
  bird=source.resize((px,px),Image.Resampling.NEAREST)
  icon.alpha_composite(bird)
  icon.save(icons/('icon_%dx%d%s.png'%(size,size,'@2x' if scale==2 else '')))
subprocess.run(['iconutil','-c','icns',str(icons),'-o',str(res/'ParlakIsler.icns')],check=True)
info=dict(CFBundleName='Parlak İşler',CFBundleDisplayName='Parlak İşler',CFBundleExecutable='ParlakIsler',CFBundleIdentifier='com.parlakisler.game',CFBundlePackageType='APPL',CFBundleShortVersionString='0.3.0',CFBundleVersion='0.3.0',CFBundleIconFile='ParlakIsler.icns',NSHighResolutionCapable=True,LSMinimumSystemVersion='12.0',NSHumanReadableCopyright='Godot motoru ve varlık kaynakları Resources klasöründedir.')
with (app/'Contents/Info.plist').open('wb') as f:plistlib.dump(info,f)
subprocess.run(['codesign','--force','--deep','--sign','-',str(app)],check=True)
subprocess.run(['ditto','-c','-k','--sequesterRsrc','--keepParent',str(app),str(root/'builds/Parlak-Isler-0.3.0-macOS.zip')],check=True)
print('Hazır:',app)
