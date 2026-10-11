# Teknik mimari ve bölüm ekleme sözleşmesi

Son güncelleme: 11 Ekim 2026
Durum: Godot 4.7.2 üzerinde Faz 1–3 teknik uygulaması tamamlandı; yerel macOS test paketi hazır. Aşağıdaki uzun vadeli modül ayrımı hedef mimaridir.

## Temel karar

Godot 4 ve GDScript kullanılacak. Bir ortak oynanış sahnesi bölüm verisini yükler. Her bölüm için ayrı oyun döngüsü yazılmaz. Mevcut engel türlerinden oluşan yeni bölüm; veri, katalog girdisi ve gerekiyorsa görsel kaynaklar eklenerek çalışır. Yeni mekanik eklemek bileşen kodu gerektirebilir.

## Önerilen yapı

| Yol | Sorumluluk |
|---|---|
| `scenes/gameplay/` | Ortak oyun sahnesi, karga, ganimet, yuva ve engel sahneleri |
| `scenes/ui/` | Menü, bölüm seçimi, sonuç, koleksiyon ve yuva ekranları |
| `scripts/gameplay/` | Fizik, yük, bölüm akışı ve etkileşimler |
| `scripts/data/` | Bölüm kataloğu, JSON yükleme ve doğrulama |
| `scripts/save/` | Kayıt okuma, güvenli yazma ve sürüm geçişleri |
| `data/levels/` | Her bölüm için bir JSON dosyası |
| `data/level_catalog.json` | Bölüm sırası, bölge, dosya yolu ve açılma önkoşulları |
| `data/balance/` | Ortak fizik, ganimet ve dekor ayarları |
| `assets/` | Bölgeye ve varlık türüne göre görsel/ses kaynakları |
| `tests/` | Veri, kayıt ve sonuç işlemleri için anlamlı doğrulamalar |

## Sistem sınırları

- Oyuncu denetleyicisi: giriş, dikey fizik ve yük etkisi. Bölüm kimliklerini bilmez.
- Bölüm yükleyici: doğrulanmış veriden sahne örnekleri üretir; oyuncu ilerlemesini değiştirmez.
- Oyun oturumu: hazır, oynanıyor, duraklatıldı, çarpıldı ve teslim edildi durumlarını yönetir. Sonuç yalnızca bir kez kesinleşir.
- Ganimet çantası: kapasite, taşınan değer ve özel eşya listesi.
- Kayıt yöneticisi: kesinleşmiş sonuçları ve kozmetik satın alımlarını işler.
- Arayüz: sistem olaylarını gösterir; bakiye ve fizik hesaplarının sahibi değildir.

Dünya koordinatlarında oyuncu sabit yatay hızla ilerler, kamera takip eder. Rüzgâr yalnızca dikey ivme ekler. Sallanan engeller ortak bölüm zamanına bağlıdır. Yeniden deneme bu zamanı sıfırlar; duraklatma durdurur. Ekrandan çıkan varlıklar temizlenebilir; ilk sekiz bölüm için karmaşık akış sistemi zorunlu değildir.

## Bölüm veri sözleşmesi

JSON alanları da Türkçe adlandırılır. Kimlikler kalıcıdır; görünen adlar değişebilir. Aşağıdaki örnek yalnızca şemayı anlatır, tam oynanabilir bölüm değildir.

```json
{
  "sema_surumu": 1,
  "kimlik": "CATI_01",
  "ad": "İlk Kanat",
  "bolge": "cati",
  "uzunluk": 9000,
  "baslangic": {"x": 160, "y": 270},
  "deger_hedefi": 5,
  "ozel_esya_kimligi": "kirmizi_dugme",
  "nesneler": [
    {"kimlik": "baca_01", "tur": "baca", "x": 900, "y": 440, "ayarlar": {"genislik": 80, "yukseklik": 200}},
    {"kimlik": "kapak_01", "tur": "ganimet", "x": 1100, "y": 250, "ayarlar": {"esya": "kapak"}},
    {"kimlik": "son_yuva", "tur": "yuva", "x": 8700, "y": 270, "ayarlar": {"son": true}}
  ]
}
```

Konumlar mantıksal dünya birimidir; nesne konumu merkezini belirtir. Engel boyutları çarpışma ve görsel yerleşiminde birlikte kullanılır. Yuva girişleri engellerle çakışamaz. Katalog açılma önkoşullarının tek kaynağıdır; bölüm dosyalarında yinelenmez.

Nesne türü kayıt tablosu başlangıçta `baca`, `anten`, `ganimet`, `ozel_esya`, `yuva`; Faz 2'de `ruzgar` ve `sallanan_yuk` içerir. JSON keyfî betik veya çalıştırılabilir kaynak yolu içermez; türler izin verilen sahnelere eşlenir.

## Veri doğrulama

- Desteklenmeyen şema, yinelenen bölüm/nesne kimliği veya bilinmeyen nesne türü reddedilir.
- Süreyi etkileyen uzunluk, boyut ve hareket periyotları pozitif olmalıdır; koordinatlar sonlu olmalıdır.
- Her bölümde tam bir son yuva bulunmalıdır; başlangıçtan sonra ve bölüm sınırı içinde olmalıdır.
- Katalog önkoşulları mevcut olmalı ve döngü oluşturmamalıdır.
- Başvurulan ganimet, özel eşya ve görsel tema mevcut olmalıdır.
- Hata mesajı dosya, nesne kimliği ve sorunlu alanı belirtir. Hatalı bölüm seçilemez; diğer geçerli bölümler çalışabilir.
- Şema doğrulaması oynanabilirliği kanıtlamaz. Zorunlu geçitler boş/tam yükle ayrıca denenir.

## Kayıt ve güncelleme uyumluluğu

Kayıt `user://` altında tutulur. Alanlar: kayıt sürümü, bakiye, bölüm kimliğine bağlı tamamlanma ve en iyi teslim, teslim edilen özel eşya kimlikleri, satın alınmış dekorlar, seçili dekorlar, ayarlar ve son işlenen oturum kimliği.

Kayıt önce geçici dosyaya yazılır, doğrulanır ve önceki dosyanın yedeği korunarak değiştirilir. Sonuç aynı oturum kimliğiyle tekrar gelirse bakiye tekrar artırılmaz. Bozuk kayıt önce yedekten kurtarılmaya çalışılır; kurtarılamazsa kullanıcıya anlaşılır bilgi verilir, bozuk dosya sessizce silinmez.

Bölüm sırasına veya dizi indeksine göre kayıt yapılmaz. Yeni bölümün kayıt girdisi yoksa tamamlanmamış kabul edilir. Tanınmayan eski bölüm kimlikleri korunur. Mevcut bölüm kimlikleri yeniden kullanılmaz. Kayıt şeması değişirse açık sürüm geçişi eklenir; eski sürüm örnek kaydıyla test edilir.

## Yeni bölüm ekleme kontrolü

1. Benzersiz kimlik seç, mevcut şemayla bölüm dosyasını oluştur.
2. Kataloğa sıra, bölge, yol ve önkoşulları ekle.
3. Mevcut türlerle tasarla; yeni tür gerekiyorsa bileşen kaydı ve parametre doğrulamasını ekle.
4. Veri doğrulamasını çalıştır ve oyun içi bölüm seçimini kontrol et.
5. Son yuvaya boş/tam yükle ulaş; ara teslim, özel eşya ve yeniden denemeyi kontrol et.
6. Eski kayıtla açılışı ve yeni bölümün doğru kilit durumunu doğrula.
7. PRD, plan ve oyuncu yolculuğunu güncelle.

Bu sürümde uzaktan içerik indirme yoktur. Yeni bölümler oyun güncellemesiyle paketlenir.

## Faz 1'deki somut uygulama

- `scenes/main.tscn`: ortak giriş sahnesi.
- `scripts/game.gd`: uçuş, etkileşimler, çizim ve arayüz. Prototipte bunlar tek koordinatörde; Faz 2 öncesinde ayrı bileşenlere ayrılabilir.
- `scripts/levels.gd`: veri yükleme, kimlik/tür/boyut/önkoşul doğrulaması.
- `scripts/save_store.gd`: kayıt, yedek kurtarma ve tekrar teslim koruması.
- Gerçek JSON şemasında nesne boyutları `w`/`h`, ganimet türü `esya`, yuva tipi `son` alanlarıyla doğrudan nesnede tutulur; yukarıdaki `ayarlar` örneği ilk tasarım örneğidir. Yeni bölüm için mevcut `data/levels/cati_01.json` dosyasını esas al.
- Özel eşyalar sekiz bölüme bağlandı; koleksiyon ve dekorlar kayıt sürümü 2 ile saklanır. Temel fizik değerleri oyun betiğindedir.

## Çalıştırma

Godot konumu: `/Users/mytkn/Downloads/Godot.app/Contents/MacOS/Godot`.
Godot sürümü: `4.7.2.stable.official.ed1daf0bf`.
Mevcut klasördeki `project.godot` dosyasını Godot'a aktar ve F6 yerine tüm proje için F5 ile çalıştır.

```sh
/Users/mytkn/Downloads/Godot.app/Contents/MacOS/Godot --path /Users/mytkn/Desktop/myGames/flappy-bird
/Users/mytkn/Downloads/Godot.app/Contents/MacOS/Godot --headless --path /Users/mytkn/Desktop/myGames/flappy-bird --script tests/smoke.gd
```

Kontroller: Boşluk veya sol tık uçuş; Esc duraklat/dön; sonuç ekranında R tekrar deneme. Son yuvaya ulaşınca sıradaki bölüm açılır. Kayıt Godot'un standart kullanıcı verisi dizinindeki `ilerleme.json` dosyasındadır. Testler ayrı geçici kayıt dosyası kullanır ve oyun ilerlemesini değiştirmez.

## Faz 2 teknik ekleri

`environment.gd` rüzgâr alanı kuvvetini ve sallanan yük konumunu hesaplar. Oyun aynı konumu çizimde ve çarpışmada kullanır. Rüzgâr nesnesi `w`, `h`, `kuvvet`; yük nesnesi `w`, `h`, `genlik`, `periyot`, `evre` alanlarını taşır. Negatif kuvvet yukarıdır. Örnekler `data/levels/liman_*.json` içindedir.

Bölüm kökündeki `ozel_esya_adi` görünen adı, `ozel_esya_turu` izinli görsel anahtarını belirler. Koleksiyon sahipliği kalıcı bölüm kimliğiyle saklanır; bilinmeyen görsel türünde madalya kullanılır. Bölüm seçimi dörderli sayfalıdır; sekizin üzerinde bölümlerde ek gezinme düğmeleri görünür.

Kayıt sürümü 2; sürüm 1 okununca `koleksiyon`, `dekorlar`, `secili_dekorlar` boş listelerle tamamlanır. İlk sonraki kayıt yazımında sürüm 2 yazılır; eski geçerli dosya yedeklenir. Başarı işaretleri kalıcı tamamlanma, en iyi tek teslimin bölüm hedefini geçmesi ve koleksiyon sahipliğinden hesaplanır.

Müzik dosyaları `tools/prepare_music.py`, Liman görselleri `tools/prepare_harbor_art.py` ile hazırlanabilir. Kaynak atlaslar korunur. `tests/phase2_preview.gd` görsel kontrol için bellekte örnek ilerleme kullanır; oyuncunun kaydına yazmaz.

## Faz 3 ayarlar, kayıt ve dağıtım

Kayıt sürümü 3, `ayarlar` sözlüğünü ekler. `ucus_tusu`, `duraklat_tusu`, `tekrar_tusu`, `muzik`, `efekt`, `hiz`, `az_hareket` alanları sürüm 1/2 kayıtlarına varsayılanlarla eklenir. Geçerli eski dosya yedeklenmeden yenisi yerleştirilmez. Başarısız teslim işlemi bellekteki bakiye/başarı/oturum kimliğini de geri alır; aynı teslim yeniden denenebilir. Daha yeni sürüm kaydı varsa yedeğe dönülerek üzerine yazılmaz.

`_physics_process` yardımcı hızla bir simülasyon biriktiricisini ilerletir; `simulate_step` sabit 1/60 saniyelik adım kullanır. Böylece %50 hızda aynı simülasyon sonucu iki kat duvar süresinde elde edilir. Arayüz ve ses hızı değişmez. Pencere odak kaybı oyunu duraklatır.

`LevelStore.load_levels(catalog_path)` alternatif katalog kabul eder. Testler geçici dokuzuncu bölümü bu yolla yükler; mevcut oyuncu kataloğu değişmez. Eksik kaynak, hatalı tür/boyut, önkoşul, yinelenen kimlik ve hareket parametreleri doğrulanır.

`export_presets.cfg` PCK oluşturur. `tools/build_macos.py`, mevcut Godot universal çalıştırıcısı ve `tools/macos_launcher.c` ile bağımsız yerel `.app` ve ZIP üretir. Resmî export template yerine editör çalıştırıcısı içerildiğinden paket daha büyüktür. Paket Apple noter onaylı değildir. Testler ve ham üretim atlasları PCK'ya dahil edilmez; varlık manifesti ve Godot lisans metinleri ayrıca eklenir.
