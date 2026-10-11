# Parlak İşler 0.3.0 — Yerel test sürümü

11 Ekim 2026

## Bu sürüm

Sekiz bölüm, iki bölge, ganimet ve yük yönetimi, erken teslim, kalıcı koleksiyon ve dört yuva dekoru içerir. Ayarlar ekranından uçuş/duraklatma/tekrar tuşları, ayrı müzik ve efekt düzeyleri, %75/%50 yardımcı hız ve azaltılmış hareket seçilebilir. Yardımcı hız ödülleri değiştirmez. Pencere odak kaybedince uçuş duraklar.

Kayıt sürümü 3'tür. Önceki sürüm 1 ve 2 kayıtları okunur; ilk başarılı kayıtta yükseltilir. Başarısız disk yazımı teslimi ve satın almayı geri alır; daha yeni kayıtların üzerine yazılmaz. Bölüm eklemek için veri dosyası ve katalog girdisi yeterlidir; dokuzuncu bölümle otomatik test yapılmıştır.

## Açılış ve kontroller

`builds/Parlak Isler.app` dosyasına çift tıklayın. Paket kendi Godot çalıştırıcısını içerir. Varsayılan uçuş Boşluk/sol tık, duraklatma Esc veya P, sonuç ekranında tekrar R. Ayarlar menüden veya duraklatma ekranından açılır. Liman, dördüncü Çatı bölümünün son yuvasına ulaşınca açılır.

Mevcut oyuncu kaydı standart Godot kullanıcı klasöründe korunur: `~/Library/Application Support/Godot/app_userdata/Parlak İşler/ilerleme.json`. Yedek `.bak` uzantılıdır. Paketle proje aynı kayıt konumunu kullanır; eski ve yeni sürümleri aynı anda oynamayın.

## Paket kapsamı

macOS universal (Apple Silicon + Intel) yerel paket ve ZIP. Kurulu Godot 4.7.2 editör çalıştırıcısı içerilir; resmî dışa aktarım şablonu bu makinede kurulu değildir. Bu nedenle paket boyutu standart release export'tan büyüktür. Yerel ad-hoc imza vardır; Apple noter onayı ve mağaza yayını yapılmadı. Intel mimarisi pakette yer alır; çalışma testi Apple M3 Max üzerinde yapılmıştır.

Godot ve üçüncü taraf motor lisans metinleri uygulamanın Resources/GODOT-LICENSES.txt dosyasındadır. Görsel üretim kaynakları ASSET-SOURCES.json içinde listelenir. Higgsfield görselleri bağlı hesapta üretildi; ayrıca bir ticari lisans belgesi alınmadı. Ses ve müzik proje için matematiksel sentezle üretildi.

## Bilinen sınırlar

- İnsan oyuncu testleri henüz yapılmadı; zorluk ve dekor fiyatları geçici denge değerleridir.
- Arka planlar tek katmanlı aynalı panoramalardır; yük kesesi kodla çizilir.
- Dokunmatik, Windows ve Linux paketleri bu teslim kapsamına dahil değildir.
- Performans sonucu tek test cihazı ve yoğun sahne ölçümüne dayanır.

## Yeniden paketleme

`python3 tools/build_macos.py` Godot veri paketini üretir ve macOS uygulamasını paketler. Godot yolu betikte tanımlıdır; Python/Pillow ve Xcode komut satırı derleyicisi gerekir. Test ve ham üretim dosyaları oyun veri paketine dahil edilmez.
