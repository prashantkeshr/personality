// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Personality';

  @override
  String get navHome => 'Beranda';

  @override
  String get navHealth => 'Kesehatan';

  @override
  String get navAnalyze => 'Analisis';

  @override
  String get navCoach => 'Pelatih';

  @override
  String get navStyle => 'Gaya';

  @override
  String get todayTitle => 'Hari ini';

  @override
  String get homeEmptyTitle => 'Harimu dimulai di sini';

  @override
  String get homeEmptyBody =>
      'Rencana harian dan kemajuanmu akan muncul di sini saat fitur pelacakan tersedia.';

  @override
  String get sectionFeatures => 'Fitur';

  @override
  String get healthIntro =>
      'Pantau tubuh, nutrisi, tidur, dan aktivitas harianmu.';

  @override
  String get analyzeIntro =>
      'Analisis kamera di perangkat. Gambar diproses di ponselmu lalu dibuang.';

  @override
  String get coachIntro =>
      'Rekomendasi berasal dari aturan yang transparan. Pelatih AI opsional dapat menjelaskannya.';

  @override
  String get styleIntro =>
      'Pakaian, warna, dan padu padan sesuai ukuran dan seleramu.';

  @override
  String get featureStateAvailable => 'Tersedia';

  @override
  String get featureStateBeta => 'Beta';

  @override
  String get featureStateComingSoon => 'Segera hadir';

  @override
  String get featureStateDeviceRequired => 'Tidak didukung di perangkat ini';

  @override
  String get featureStateModelRequired => 'Perlu model';

  @override
  String get featureStateOnlineRequired => 'Perlu internet';

  @override
  String get featureStatePremium => 'Premium';

  @override
  String get featureProfile => 'Profil';

  @override
  String get featureHeight => 'Tinggi badan';

  @override
  String get featureBodyMeasurements => 'Ukuran tubuh';

  @override
  String get featureWeight => 'Berat badan';

  @override
  String get featureWater => 'Air';

  @override
  String get featureMeals => 'Makanan';

  @override
  String get featureSleep => 'Tidur';

  @override
  String get featureActivity => 'Aktivitas';

  @override
  String get featureExercise => 'Olahraga';

  @override
  String get featureHabits => 'Kebiasaan';

  @override
  String get featureRoutines => 'Rutinitas';

  @override
  String get featureReminders => 'Pengingat';

  @override
  String get featureProgress => 'Kemajuan';

  @override
  String get featureCameraHeight => 'Perkiraan tinggi dengan kamera';

  @override
  String get featurePosture => 'Analisis postur';

  @override
  String get featureExerciseTracking => 'Pelacakan olahraga';

  @override
  String get featureFace => 'Analisis wajah';

  @override
  String get featureStyle => 'Rekomendasi gaya';

  @override
  String get featureWardrobe => 'Lemari pakaian';

  @override
  String get featureAiCoach => 'Pelatih AI';

  @override
  String get featureHealthIntegration => 'Data terhubung';

  @override
  String get featureBackup => 'Cadangan terenkripsi';

  @override
  String get featureCommerce => 'Belanja';

  @override
  String get onboardingWelcomeTitle => 'Ruang pribadi untuk kesejahteraanmu';

  @override
  String get onboardingWelcomeBody =>
      'Pantau tubuh, kesehatan, kebiasaan, dan gaya di satu tempat. Semua berjalan tanpa internet.';

  @override
  String get onboardingPrivacyTitle => 'Datamu tetap di perangkat ini';

  @override
  String get onboardingPrivacyEncrypted =>
      'Catatan disimpan di basis data terenkripsi di ponsel ini.';

  @override
  String get onboardingPrivacyCamera =>
      'Analisis kamera berjalan di perangkat. Gambar tidak disimpan kecuali kamu memilih menyimpannya.';

  @override
  String get onboardingPrivacyAccount => 'Tidak perlu akun.';

  @override
  String get onboardingPrivacyAi =>
      'AI bersifat opsional. Aplikasi berfungsi penuh tanpanya.';

  @override
  String get onboardingPrefsTitle => 'Atur preferensimu';

  @override
  String get onboardingPrefsBody =>
      'Kamu bisa mengubahnya kapan saja di Setelan.';

  @override
  String onboardingStep(int current, int total) {
    return 'Langkah $current dari $total';
  }

  @override
  String get actionNext => 'Berikutnya';

  @override
  String get actionBack => 'Kembali';

  @override
  String get actionGetStarted => 'Mulai';

  @override
  String get actionRetry => 'Coba lagi';

  @override
  String get settingsTitle => 'Setelan';

  @override
  String get settingsAppearance => 'Tampilan';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get settingsUnits => 'Satuan';

  @override
  String get unitsMetric => 'Metrik (cm, kg, L)';

  @override
  String get unitsImperial => 'Imperial (ft/in, lb, oz)';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get languageSystem => 'Bahasa perangkat';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get settingsPrivacy => 'Privasi';

  @override
  String get privacyStorageSummary =>
      'Datamu hanya disimpan di perangkat ini, dalam basis data terenkripsi.';

  @override
  String get settingsAbout => 'Tentang';

  @override
  String get wellnessDisclaimer =>
      'Personality mendukung kebiasaan sehat dan gaya hidup. Aplikasi ini tidak memberikan nasihat atau diagnosis medis.';

  @override
  String get settingsSaveError => 'Setelan tidak dapat disimpan. Coba lagi.';

  @override
  String get startupErrorTitle => 'Tidak dapat membuka datamu';

  @override
  String get startupErrorBody =>
      'Personality tidak dapat membuka penyimpanan amannya. Datamu tidak berubah.';

  @override
  String get featureBodyProportions => 'Proporsi tubuh';

  @override
  String get sourceUserEntered => 'Manual';

  @override
  String get sourceCameraDerived => 'Perkiraan kamera';

  @override
  String get sourceDeviceDerived => 'Perangkat';

  @override
  String get sourceHealthPlatform => 'Platform kesehatan';

  @override
  String get sourceCalculated => 'Dihitung';

  @override
  String get sourceImported => 'Diimpor';

  @override
  String get sourceAiGenerated => 'Dibuat AI';

  @override
  String get confidenceLow => 'Keyakinan rendah';

  @override
  String get confidenceMedium => 'Keyakinan sedang';

  @override
  String get confidenceHigh => 'Keyakinan tinggi';

  @override
  String valueCm(String value) {
    return '$value cm';
  }

  @override
  String valueKg(String value) {
    return '$value kg';
  }

  @override
  String valueLb(String value) {
    return '$value lb';
  }

  @override
  String valueIn(String value) {
    return '$value in';
  }

  @override
  String valueFtIn(String feet, String inches) {
    return '$feet ft $inches in';
  }

  @override
  String get unitCmShort => 'cm';

  @override
  String get unitKgShort => 'kg';

  @override
  String get unitLbShort => 'lb';

  @override
  String get unitInShort => 'in';

  @override
  String get unitFtShort => 'ft';

  @override
  String get actionSave => 'Simpan';

  @override
  String get actionCancel => 'Batal';

  @override
  String get actionDelete => 'Hapus';

  @override
  String get deleteRecordTitle => 'Hapus catatan ini?';

  @override
  String get deleteRecordBody =>
      'Ini menghapus catatan dari perangkat ini secara permanen.';

  @override
  String get recordSaveError => 'Tidak dapat menyimpan. Coba lagi.';

  @override
  String get loadErrorTitle => 'Tidak dapat memuat';

  @override
  String get loadErrorBody =>
      'Informasi ini tidak dapat dimuat. Datamu tidak berubah.';

  @override
  String get fieldDate => 'Tanggal';

  @override
  String get fieldNotes => 'Catatan (opsional)';

  @override
  String get fieldMethod => 'Bagaimana diukur?';

  @override
  String get methodSelfMeasured => 'Diukur sendiri';

  @override
  String get methodMeasuredByOther => 'Diukur orang lain';

  @override
  String get methodProfessional => 'Pengukuran profesional';

  @override
  String get methodScale => 'Timbangan';

  @override
  String get methodEstimated => 'Perkiraanku';

  @override
  String get validationRequired => 'Masukkan nilai';

  @override
  String validationRange(String min, String max) {
    return 'Masukkan nilai antara $min dan $max';
  }

  @override
  String get historyTitle => 'Riwayat';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileIntro =>
      'Semua di sini opsional dan tetap di perangkat ini.';

  @override
  String get profileName => 'Nama (opsional)';

  @override
  String get profileAgeRange => 'Rentang usia';

  @override
  String get profileActivityLevel => 'Tingkat aktivitas';

  @override
  String get profileGoals => 'Tujuan';

  @override
  String get notSpecified => 'Tidak ditentukan';

  @override
  String get profileSaved => 'Profil disimpan';

  @override
  String get ageUnder18 => 'Di bawah 18';

  @override
  String get age18to24 => '18–24';

  @override
  String get age25to34 => '25–34';

  @override
  String get age35to44 => '35–44';

  @override
  String get age45to54 => '45–54';

  @override
  String get age55to64 => '55–64';

  @override
  String get age65plus => '65+';

  @override
  String get activitySedentary => 'Lebih banyak duduk';

  @override
  String get activityLight => 'Sedikit aktif';

  @override
  String get activityModerate => 'Cukup aktif';

  @override
  String get activityActive => 'Aktif';

  @override
  String get activityVeryActive => 'Sangat aktif';

  @override
  String get goalPosture => 'Postur';

  @override
  String get goalWeightManagement => 'Pengelolaan berat badan';

  @override
  String get goalFitness => 'Kebugaran';

  @override
  String get goalFlexibility => 'Kelenturan dan mobilitas';

  @override
  String get goalHydration => 'Hidrasi';

  @override
  String get goalSleep => 'Tidur';

  @override
  String get goalHabits => 'Kebiasaan dan rutinitas';

  @override
  String get goalStyle => 'Gaya';

  @override
  String get goalGrooming => 'Perawatan diri';

  @override
  String get heightTitle => 'Tinggi badan';

  @override
  String get heightEmpty =>
      'Tambahkan tinggi badanmu untuk rekomendasi proporsi tubuh dan pakaian yang lebih baik.';

  @override
  String get heightAdd => 'Tambah tinggi badan';

  @override
  String get heightPrimary => 'Tinggi badan utama';

  @override
  String get heightPinnedNote =>
      'Kamu memilih catatan ini sebagai tinggi badan utama.';

  @override
  String get heightLatestManualNote => 'Memakai pengukuran manual terbarumu.';

  @override
  String get heightVariationNote =>
      'Tinggi badan secara alami berubah sekitar 1–2 cm sepanjang hari. Selisih kecil antarcatatan itu normal dan tidak dihitung sebagai pertumbuhan.';

  @override
  String get heightSetPrimary => 'Jadikan utama';

  @override
  String get weightTitle => 'Berat badan';

  @override
  String get weightEmpty =>
      'Tambahkan catatan berat badan pertamamu untuk mulai melihat tren.';

  @override
  String get weightAdd => 'Tambah berat badan';

  @override
  String get weightLatest => 'Terbaru';

  @override
  String get weightGoalRange => 'Rentang target';

  @override
  String get weightGoalNotSet => 'Belum ada rentang target';

  @override
  String get weightSetGoal => 'Atur';

  @override
  String get weightGoalMin => 'Dari';

  @override
  String get weightGoalMax => 'Sampai';

  @override
  String get weightGoalInvalid =>
      'Nilai kedua harus lebih besar dari yang pertama.';

  @override
  String get weightClearGoal => 'Hapus';

  @override
  String get goalBelow => 'Di bawah rentang targetmu';

  @override
  String get goalWithin => 'Dalam rentang targetmu';

  @override
  String get goalAbove => 'Di atas rentang targetmu';

  @override
  String get periodWeek => 'Minggu';

  @override
  String get periodMonth => 'Bulan';

  @override
  String get periodQuarter => '3 bulan';

  @override
  String weightTrendChange(String change) {
    return 'Perubahan rata-rata 7 hari pada periode ini: $change';
  }

  @override
  String get weightTrendInsufficient =>
      'Tambahkan setidaknya dua catatan pada periode ini untuk melihat tren.';

  @override
  String weightChartLabel(int count) {
    return 'Grafik berat badan dengan $count catatan';
  }

  @override
  String get weightAverageLegend => 'Rata-rata 7 hari';

  @override
  String get weightEntriesLegend => 'Catatan';

  @override
  String get measurementsTitle => 'Ukuran tubuh';

  @override
  String get measurementsIntro =>
      'Opsional. Dipakai untuk proporsi tubuh dan ukuran pakaian. Ukur di atas pakaian tipis dengan meteran kain.';

  @override
  String get measurementNotRecorded => 'Belum dicatat';

  @override
  String get measurementAdd => 'Tambah ukuran';

  @override
  String get measurementCustom => 'Ukuran khusus';

  @override
  String get measurementCustomLabel => 'Nama ukuran';

  @override
  String get measurementType => 'Ukuran';

  @override
  String get mShoulderWidth => 'Lebar bahu';

  @override
  String get mChest => 'Dada';

  @override
  String get mWaist => 'Pinggang';

  @override
  String get mHip => 'Pinggul';

  @override
  String get mNeck => 'Leher';

  @override
  String get mArmLength => 'Panjang lengan';

  @override
  String get mLegLength => 'Panjang kaki';

  @override
  String get mTorsoLength => 'Panjang badan';

  @override
  String get mInseam => 'Panjang kaki dalam';

  @override
  String get mShoulderWidthHelp =>
      'Lurus melintasi punggung, dari ujung bahu ke ujung bahu.';

  @override
  String get mChestHelp =>
      'Mengelilingi bagian dada terlebar, dengan meteran sejajar.';

  @override
  String get mWaistHelp => 'Mengelilingi pinggang alami, tepat di atas pusar.';

  @override
  String get mHipHelp => 'Mengelilingi bagian pinggul terlebar.';

  @override
  String get mNeckHelp => 'Mengelilingi pangkal leher.';

  @override
  String get mArmLengthHelp =>
      'Dari ujung bahu ke pergelangan tangan, dengan lengan rileks.';

  @override
  String get mLegLengthHelp =>
      'Dari tulang pinggul ke lantai, di sisi luar kaki.';

  @override
  String get mTorsoLengthHelp => 'Dari puncak bahu ke pinggang alami.';

  @override
  String get mInseamHelp => 'Dari selangkangan ke lantai, di sisi dalam kaki.';

  @override
  String get proportionsTitle => 'Proporsi tubuh';

  @override
  String get proportionsIntro =>
      'Deskripsi netral untuk ukuran pakaian dan saran siluet.';

  @override
  String get proportionsDisclaimer =>
      'Ini bukan penilaian kesehatan atau penampilan, dan tidak ada bentuk tubuh yang ideal.';

  @override
  String get proportionsEmpty =>
      'Tambahkan tinggi badan dan beberapa ukuran untuk melihat proporsimu.';

  @override
  String proportionsMissing(String items, String metric) {
    return 'Tambahkan $items untuk melihat $metric.';
  }

  @override
  String proportionsBasedOn(String inputs) {
    return 'Berdasarkan: $inputs';
  }

  @override
  String get proportionsAddMeasurements => 'Ukuran';

  @override
  String get metricLegLine => 'Garis kaki';

  @override
  String get metricShoulderBreadth => 'Lebar bahu';

  @override
  String get metricUpperTaper => 'Selisih dada-pinggang';

  @override
  String get metricHipBalance => 'Keseimbangan pinggul-dada';

  @override
  String get descShorterLegLine =>
      'Garis kaki lebih pendek dibanding tinggi badan';

  @override
  String get descBalancedLegLine => 'Garis kaki seimbang';

  @override
  String get descLongerLegLine =>
      'Garis kaki lebih panjang dibanding tinggi badan';

  @override
  String get descNarrowerShoulders =>
      'Bahu lebih sempit dibanding tinggi badan';

  @override
  String get descAverageShoulders =>
      'Lebar bahu di rentang tengah untuk tinggimu';

  @override
  String get descBroaderShoulders => 'Bahu lebih lebar dibanding tinggi badan';

  @override
  String get descStraightTaper => 'Garis badan lebih lurus';

  @override
  String get descModerateTaper => 'Mengecil sedang dari dada ke pinggang';

  @override
  String get descPronouncedTaper => 'Mengecil jelas dari dada ke pinggang';

  @override
  String get descChestFuller => 'Lingkar dada lebih besar dari pinggul';

  @override
  String get descBalancedChestHip => 'Lingkar dada dan pinggul mirip';

  @override
  String get descHipsFuller => 'Lingkar pinggul lebih besar dari dada';

  @override
  String valueFlOz(String value) {
    return '$value fl oz';
  }

  @override
  String valueLitres(String value) {
    return '$value L';
  }

  @override
  String valueMl(String value) {
    return '$value ml';
  }

  @override
  String durationHm(int hours, int minutes) {
    return '$hours j $minutes m';
  }

  @override
  String valueMinutes(int minutes) {
    return '$minutes mnt';
  }

  @override
  String valueSteps(String value) {
    return '$value langkah';
  }

  @override
  String valueKm(String value) {
    return '$value km';
  }

  @override
  String valueMiles(String value) {
    return '$value mi';
  }

  @override
  String valueKcal(int value) {
    return '$value kkal';
  }

  @override
  String get mealBreakfast => 'Sarapan';

  @override
  String get mealLunch => 'Makan siang';

  @override
  String get mealSnack => 'Camilan';

  @override
  String get mealDinner => 'Makan malam';

  @override
  String get mealCustom => 'Lainnya';

  @override
  String get activityWalking => 'Jalan kaki';

  @override
  String get activityRunning => 'Lari';

  @override
  String get activityCycling => 'Bersepeda';

  @override
  String get activitySwimming => 'Berenang';

  @override
  String get activitySports => 'Olahraga permainan';

  @override
  String get activityOther => 'Aktivitas lain';

  @override
  String get exNeck => 'Leher';

  @override
  String get exShoulder => 'Bahu';

  @override
  String get exUpperBack => 'Punggung atas';

  @override
  String get exLowerBack => 'Punggung bawah';

  @override
  String get exCore => 'Otot inti';

  @override
  String get exMobility => 'Mobilitas';

  @override
  String get exYoga => 'Yoga';

  @override
  String get exStretching => 'Peregangan';

  @override
  String get exPosture => 'Postur';

  @override
  String get exGeneralFitness => 'Kebugaran umum';

  @override
  String get exStrength => 'Kekuatan';

  @override
  String get exCardio => 'Kardio';

  @override
  String get targetOutOfRange => 'Nilai ini di luar rentang yang didukung.';

  @override
  String get targetsTitle => 'Target harian';

  @override
  String get targetsIntro =>
      'Ini titik awal yang bisa kamu ubah kapan saja. Bukan rekomendasi medis.';

  @override
  String get unitLitreShort => 'L';

  @override
  String get unitFlOzShort => 'fl oz';

  @override
  String get unitHoursShort => 'j';

  @override
  String get unitMinutesShort => 'mnt';

  @override
  String get unitMlShort => 'ml';

  @override
  String get unitKmShort => 'km';

  @override
  String get unitMiShort => 'mi';

  @override
  String get stepsLabel => 'Langkah';

  @override
  String get activeMinutesLabel => 'Menit aktif';

  @override
  String get waterCustom => 'Jumlah khusus';

  @override
  String get actionAdd => 'Tambah';

  @override
  String get actionEdit => 'Ubah';

  @override
  String ofTarget(String value) {
    return 'Target: $value';
  }

  @override
  String get lastSevenDays => '7 hari terakhir';

  @override
  String weekChartLabel(String metric) {
    return '$metric selama 7 hari terakhir';
  }

  @override
  String get todayEntries => 'Catatan hari ini';

  @override
  String get waterEmpty => 'Belum ada air yang dicatat hari ini.';

  @override
  String get mealAdd => 'Catat makanan';

  @override
  String get mealsEmpty =>
      'Catat apa yang kamu makan, dengan kata-katamu sendiri. Kalori opsional.';

  @override
  String get mealType => 'Waktu makan';

  @override
  String get mealCustomName => 'Nama (opsional)';

  @override
  String get mealFood => 'Apa yang kamu makan?';

  @override
  String get mealQuantity => 'Jumlah (opsional)';

  @override
  String get mealCalories => 'Kalori (opsional)';

  @override
  String get mealCaloriesHelp => 'Hanya jika kamu ingin melacaknya.';

  @override
  String get fieldTime => 'Waktu';

  @override
  String get sleepAdd => 'Catat tidur';

  @override
  String get sleepLastNight => 'Tadi malam';

  @override
  String get sleepConsistencyInsufficient =>
      'Catat setidaknya dua malam minggu ini untuk melihat seberapa konsisten jam tidurmu.';

  @override
  String sleepConsistency(int minutes) {
    return 'Jam tidurmu berbeda sekitar $minutes mnt minggu ini.';
  }

  @override
  String get sleepDisclaimer =>
      'Pelacakan tidur di sini untuk kesadaran pribadi dan tidak menilai gangguan tidur.';

  @override
  String get sleepEmpty => 'Belum ada tidur yang dicatat.';

  @override
  String get sleepWakeBeforeBed => 'Jam bangun harus setelah jam tidur.';

  @override
  String get sleepTooLong => 'Catatan tidur tidak bisa lebih dari 24 jam.';

  @override
  String get sleepBedtime => 'Jam tidur';

  @override
  String get sleepWakeTime => 'Jam bangun';

  @override
  String sleepDurationPreview(String duration) {
    return 'Durasi: $duration';
  }

  @override
  String get activityAdd => 'Catat aktivitas';

  @override
  String get activeMinutesNote =>
      'Menit aktif mencakup aktivitas dan sesi olahraga.';

  @override
  String get activityEmpty =>
      'Belum ada aktivitas yang dicatat. Impor langkah otomatis dari Health Connect menyusul.';

  @override
  String get activityNeedsValue => 'Masukkan langkah, durasi, atau jarak.';

  @override
  String get activityKindLabel => 'Aktivitas';

  @override
  String get durationLabel => 'Durasi';

  @override
  String get distanceLabel => 'Jarak (opsional)';

  @override
  String get exerciseAdd => 'Catat olahraga';

  @override
  String get exerciseEmpty =>
      'Catat olahraga yang sudah kamu lakukan. Pustaka latihan terpandu hadir di pembaruan berikutnya.';

  @override
  String get exerciseThisWeek => 'Minggu ini';

  @override
  String setsReps(int sets, int reps) {
    return '$sets × $reps';
  }

  @override
  String get exerciseName => 'Latihan';

  @override
  String get exerciseCategory => 'Kategori';

  @override
  String get setsLabel => 'Set (opsional)';

  @override
  String get repsLabel => 'Repetisi (opsional)';

  @override
  String get habitAdd => 'Tambah kebiasaan';

  @override
  String get habitEdit => 'Ubah kebiasaan';

  @override
  String get habitsEmpty =>
      'Tambahkan kebiasaan kecil yang ingin kamu ulangi, lalu pilih harinya.';

  @override
  String habitsTodaySummary(int done, int total) {
    return 'Hari ini kamu menyelesaikan $done dari $total kebiasaan.';
  }

  @override
  String get habitsNotToday => 'Tidak dijadwalkan hari ini';

  @override
  String habitWeekAdherence(int done, int total) {
    return '$done dari $total minggu ini';
  }

  @override
  String get habitSkippedToday => 'Dilewati hari ini';

  @override
  String get habitSkip => 'Lewati';

  @override
  String get habitUndo => 'Urungkan';

  @override
  String get habitArchive => 'Arsipkan';

  @override
  String get habitName => 'Kebiasaan';

  @override
  String get habitDays => 'Hari';

  @override
  String get habitDaysRequired => 'Pilih minimal satu hari.';

  @override
  String get habitsNoneToday => 'Tidak ada hari ini';

  @override
  String get homeBodyTitle => 'Tubuh';

  @override
  String mealsLogged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kali makan',
      one: '1 kali makan',
      zero: 'Belum dicatat',
    );
    return '$_temp0';
  }

  @override
  String get planTitle => 'Rencana hari ini';

  @override
  String get routineNew => 'Rutinitas baru';

  @override
  String get routinesEmpty =>
      'Buat rutinitas harian dengan waktu untuk minum, makan, bergerak, dan istirahat. Pengingat bersifat opsional.';

  @override
  String get routineFromExample => 'Mulai dari contoh';

  @override
  String get templateRoutineName => 'Rutinitas harian saya';

  @override
  String get newRoutineName => 'Rutinitas baru';

  @override
  String routineItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
      one: '1 item',
      zero: 'Tanpa item',
    );
    return '$_temp0';
  }

  @override
  String get everyDay => 'Setiap hari';

  @override
  String get routineNotFound => 'Rutinitas ini sudah tidak ada.';

  @override
  String get actionDuplicate => 'Duplikat';

  @override
  String routineCopyName(String name) {
    return '$name (salinan)';
  }

  @override
  String get routineAddItem => 'Tambah item';

  @override
  String get routinePaused => 'Dijeda — tidak termasuk rencana hari ini.';

  @override
  String get routineNoItems =>
      'Belum ada item. Tambahkan waktu untuk hal yang ingin kamu lakukan.';

  @override
  String get reminderOn => 'Ingatkan saya';

  @override
  String get reminderOff => 'Tanpa pengingat';

  @override
  String get routineName => 'Nama rutinitas';

  @override
  String get routineItemTitle => 'Apa';

  @override
  String get routineItemKind => 'Jenis';

  @override
  String get kindWake => 'Bangun';

  @override
  String get kindMeal => 'Makan';

  @override
  String get kindWindDown => 'Bersantai';

  @override
  String get kindCustom => 'Lainnya';

  @override
  String get templatePostureBreak => 'Jeda postur';

  @override
  String get remindersChannelName => 'Pengingat rutinitas';

  @override
  String get remindersChannelDescription =>
      'Pengingat untuk item dalam rutinitasmu';

  @override
  String get reminderActionDone => 'Selesai';

  @override
  String get reminderActionSnooze => 'Tunda 10 mnt';

  @override
  String reminderBody(String time) {
    return 'Dijadwalkan pukul $time';
  }

  @override
  String get planEmpty =>
      'Tidak ada rencana hari ini. Buat rutinitas untuk melihat rencanamu di sini.';

  @override
  String planSummary(int done, int total) {
    return 'Selesai $done dari $total yang direncanakan';
  }

  @override
  String planBreakdown(int skipped, int missed, int moved, int open) {
    return 'Dilewati $skipped · Terlewat $missed · Dipindah $moved · Tersisa $open';
  }

  @override
  String get planWeekAdherence => 'Rencana terlaksana, 7 hari terakhir (%)';

  @override
  String get planAdherenceNote =>
      'Menunjukkan seberapa banyak rencanamu terlaksana. Ini terpisah dari hasil kesehatan seperti air atau langkah.';

  @override
  String get planUpcoming => 'Mendatang';

  @override
  String get planDue => 'Sekarang';

  @override
  String get planDone => 'Selesai';

  @override
  String get planSkipped => 'Dilewati';

  @override
  String get planMissed => 'Terlewat';

  @override
  String planMovedFrom(String time) {
    return 'dipindah dari $time';
  }

  @override
  String get planReschedule => 'Pindah ke waktu lain';

  @override
  String get planHomeEmpty => 'Belum ada rencana hari ini';

  @override
  String get planAllDone => 'Tidak ada lagi untuk hari ini';

  @override
  String planNext(String title, String time) {
    return 'Berikutnya: $title — $time';
  }

  @override
  String get suggestionTitle => 'Saran';

  @override
  String suggestionMissed(String title, String time, int count, int total) {
    return '$title pukul $time terlewat pada $count dari $total hari terjadwal terakhir.';
  }

  @override
  String suggestionLate(String title, String time, int count, int total) {
    return '$title pukul $time biasanya dilakukan lebih lambat — pada $count dari $total hari terjadwal terakhir.';
  }

  @override
  String suggestionRescheduled(String title, String time, int count) {
    return 'Kamu memindahkan $title dari $time sebanyak $count kali belakangan ini.';
  }

  @override
  String suggestionQuestion(String time) {
    return 'Pindahkan ke $time?';
  }

  @override
  String suggestionAccept(String time) {
    return 'Pindah ke $time';
  }

  @override
  String get suggestionDismiss => 'Tetap di waktu ini';

  @override
  String get notificationsBlocked =>
      'Notifikasi dimatikan untuk aplikasi ini. Rencanamu tetap berjalan di sini; aktifkan notifikasi di pengaturan Android untuk menerima pengingat.';

  @override
  String get remindersEnable => 'Pengingat rutinitas';

  @override
  String get remindersOnNote =>
      'Kamu akan diingatkan untuk item rutinitas yang pengingatnya aktif.';

  @override
  String get remindersOffNote => 'Mati. Rencanamu tetap tersedia di aplikasi.';

  @override
  String get remindersAdaptive => 'Saran waktu';

  @override
  String get remindersAdaptiveNote =>
      'Menyarankan waktu yang lebih baik bila sebuah item sering terlewat atau terlambat. Tidak ada yang berubah tanpa persetujuanmu.';

  @override
  String get remindersTimingNote =>
      'Untuk menghemat baterai, Android bisa mengirim pengingat beberapa menit terlambat.';

  @override
  String get remindersNext => 'Pengingat berikutnya';

  @override
  String get remindersNoneUpcoming =>
      'Tidak ada pengingat dalam dua hari ke depan.';

  @override
  String get featureCameraCheck => 'Cek kamera';

  @override
  String get cameraSwitch => 'Ganti kamera';

  @override
  String get cameraUnavailable =>
      'Kamera tidak dapat diakses. Pencatatan manual tetap tersedia.';

  @override
  String get cameraPermissionDenied =>
      'Akses kamera tidak diizinkan. Pencatatan manual tetap tersedia. Untuk memakai kamera, izinkan untuk Personality di pengaturan Android.';

  @override
  String get cameraFailed =>
      'Kamera tidak dapat dimulai. Tutup aplikasi lain yang memakainya lalu coba lagi.';

  @override
  String get cameraIntro =>
      'Periksa kamera dan pencahayaan. Gambar dianalisis di ponsel ini lalu dibuang — tidak ada yang disimpan atau diunggah.';

  @override
  String get cameraStart => 'Mulai kamera';

  @override
  String get cameraStop => 'Hentikan kamera';

  @override
  String get cameraPrivacyNote =>
      'Gambar kamera hanya ada di memori selama dianalisis, lalu dibuang. Kamera berhenti saat kamu meninggalkan layar ini atau berpindah aplikasi.';

  @override
  String get cameraProcessingOnDevice => 'Diproses di perangkat';

  @override
  String get cameraWaiting => 'Menunggu gambar…';

  @override
  String get cameraLighting => 'Pencahayaan';

  @override
  String get cameraAnalysisRate => 'Analisis';

  @override
  String cameraFramesStats(int fps, int frames) {
    return '$fps gambar per detik · $frames dianalisis';
  }

  @override
  String get poseModelRequired =>
      'Analisis postur memerlukan model pose, yang akan hadir di pembaruan berikutnya. Cek cahaya dan kamera sudah berfungsi.';

  @override
  String get poseNoPerson =>
      'Tidak ada orang terdeteksi. Masuklah ke dalam bingkai.';

  @override
  String get posePersonDetected => 'Orang terdeteksi';

  @override
  String get poseReposition =>
      'Masuk ke dalam panduan agar seluruh tubuhmu terlihat.';

  @override
  String get poseHoldStill => 'Diam sebentar.';

  @override
  String get cameraPowerMode => 'Mode daya kamera';

  @override
  String get powerLow => 'Hemat';

  @override
  String get powerStandard => 'Standar';

  @override
  String get powerHigh => 'Akurasi tinggi';

  @override
  String get powerLowNote =>
      'Resolusi lebih rendah, 5 analisis per detik. Hemat baterai; hasil bisa kurang stabil.';

  @override
  String get powerStandardNote =>
      'Resolusi seimbang, 10 analisis per detik. Disarankan untuk sebagian besar ponsel.';

  @override
  String get powerHighNote =>
      'Resolusi lebih tinggi, 15 analisis per detik. Hasil paling stabil; lebih boros baterai dan ponsel bisa hangat.';

  @override
  String get lightingGood => 'Cahaya bagus';

  @override
  String get lightingDim => 'Redup';

  @override
  String get lightingTooDark => 'Terlalu gelap';

  @override
  String get lightingTooBright => 'Terlalu terang';

  @override
  String get lightingLowContrast => 'Lensa tertutup?';

  @override
  String get lightingGoodAdvice => 'Pencahayaan bagus untuk analisis.';

  @override
  String get lightingDimAdvice =>
      'Masih bisa, tetapi cahaya lebih terang membuat hasil lebih stabil.';

  @override
  String get lightingTooDarkAdvice =>
      'Tambah cahaya — nyalakan lampu atau menghadap jendela.';

  @override
  String get lightingTooBrightAdvice =>
      'Terlalu terang — hindari berdiri di depan jendela yang sangat terang.';

  @override
  String get lightingLowContrastAdvice =>
      'Gambar hampir rata. Pastikan lensa tidak tertutup.';

  @override
  String get deviceInfoTitle => 'Perangkat ini';

  @override
  String get deviceInfoSubtitle => 'Perangkat keras dan kualitas pemrosesan';

  @override
  String get deviceInfoIntro =>
      'Personality menyesuaikan kualitas kamera dan analisis dengan perangkat keras ponsel ini. Hanya data perangkat keras yang dibaca; tidak ada pengenal yang dikumpulkan.';

  @override
  String get deviceUnknownNote =>
      'Data perangkat keras tidak dapat dibaca, jadi pengaturan paling aman yang dipakai.';

  @override
  String get deviceTier => 'Tingkat performa';

  @override
  String get tierHigh => 'Tinggi';

  @override
  String get tierMedium => 'Sedang';

  @override
  String get tierLow => 'Dasar';

  @override
  String get deviceRam => 'Memori';

  @override
  String get deviceCores => 'Inti prosesor';

  @override
  String get deviceAndroid => 'Versi Android';

  @override
  String get deviceStorage => 'Penyimpanan kosong';

  @override
  String get deviceCamera => 'Kamera';

  @override
  String get deviceProcessing => 'Pemrosesan';

  @override
  String get deviceAnalysisRate => 'Laju analisis bawaan';

  @override
  String get deviceCameraResolution => 'Resolusi kamera bawaan';

  @override
  String get deviceLocalAi => 'Mendukung AI lokal opsional';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get unknownValue => 'Tidak diketahui';

  @override
  String valueGb(String value) {
    return '$value GB';
  }

  @override
  String valueFps(int fps) {
    return '$fps per detik';
  }

  @override
  String get privacyCameraSummary =>
      'Analisis kamera dilakukan di ponsel ini. Gambar tidak pernah disimpan atau diunggah, kecuali kamu memilih menyimpan foto.';

  @override
  String get pmHeadTilt => 'Kemiringan kepala';

  @override
  String get pmShoulderLevel => 'Kerataan bahu';

  @override
  String get pmHipLevel => 'Kerataan pinggul';

  @override
  String get pmTorsoLean => 'Kemiringan badan';

  @override
  String get pmKneeAlignment => 'Kelurusan lutut';

  @override
  String get pmHeadForward => 'Posisi kepala';

  @override
  String get bandAligned => 'Dalam rentang biasa';

  @override
  String get bandSlight => 'Sedikit';

  @override
  String get bandNoticeable => 'Terlihat';

  @override
  String get dirNone => 'Di tengah';

  @override
  String get dirLeftHigher => 'Sisi kiri lebih tinggi';

  @override
  String get dirRightHigher => 'Sisi kanan lebih tinggi';

  @override
  String get dirTiltLeft => 'Miring ke kirimu';

  @override
  String get dirTiltRight => 'Miring ke kananmu';

  @override
  String get dirKneeLeft => 'Lebih besar di lutut kiri';

  @override
  String get dirKneeRight => 'Lebih besar di lutut kanan';

  @override
  String get dirLeanLeft => 'Condong ke kirimu';

  @override
  String get dirLeanRight => 'Condong ke kananmu';

  @override
  String get dirHeadAhead => 'Kepala di depan bahu';

  @override
  String get dirLeanForward => 'Condong ke depan';

  @override
  String get dirLeanBack => 'Condong ke belakang';

  @override
  String get viewFront => 'Tampak depan';

  @override
  String get viewSide => 'Tampak samping';

  @override
  String get poseTooFar => 'Mendekatlah sedikit ke ponsel.';

  @override
  String get poseTooClose => 'Mundur agar seluruh tubuhmu muat dalam panduan.';

  @override
  String get poseUnclearView =>
      'Hadap lurus ke kamera, atau berdiri menyamping sepenuhnya.';

  @override
  String get poseLowVisibility =>
      'Tubuhmu kurang terlihat jelas. Pakaian pas badan dan latar polos membantu.';

  @override
  String postureReady(String view) {
    return 'Siap — $view terdeteksi. Berdiri santai lalu ketuk Analisis.';
  }

  @override
  String get postureAnalyze => 'Analisis';

  @override
  String get postureCapturing => 'Diam selagi beberapa gambar dianalisis…';

  @override
  String get postureHistory => 'Riwayat postur';

  @override
  String get postureHistoryEmpty => 'Lakukan cek postur pertamamu.';

  @override
  String get postureIntro =>
      'Dapatkan perkiraan kelurusan kepala, bahu, pinggul, dan lutut. Analisis dilakukan di ponsel ini; gambar dibuang.';

  @override
  String get postureTipPhone =>
      'Sandarkan ponsel tegak kira-kira setinggi pinggang.';

  @override
  String get postureTipDistance =>
      'Berdiri 2–3 meter agar seluruh tubuhmu muat.';

  @override
  String get postureTipLight =>
      'Gunakan cahaya merata; hindari jendela terang di belakangmu.';

  @override
  String get postureTipClothes =>
      'Pakaian pas badan memudahkan melihat titik acuan.';

  @override
  String get postureTipViews =>
      'Hadap kamera untuk tampak depan, atau menyamping untuk posisi kepala.';

  @override
  String get lensFront => 'Kamera depan';

  @override
  String get lensBack => 'Kamera belakang';

  @override
  String get postureDisclaimer =>
      'Kelurusan yang diperkirakan kamera untuk pengetahuan pribadi — bukan penilaian medis atau tulang belakang. Jika ada nyeri atau keraguan, temui tenaga profesional.';

  @override
  String get postureNotReliable => 'Postur tidak dapat diukur dengan andal.';

  @override
  String postureResultTitle(String view) {
    return 'Perkiraan kelurusan · $view';
  }

  @override
  String postureFramesUsed(int count) {
    return '$count gambar';
  }

  @override
  String get postureSaved => 'Cek postur disimpan';

  @override
  String get postureSavedShort => 'Tersimpan';

  @override
  String get postureRetake => 'Ulangi';

  @override
  String get postureSuggestions => 'Saran untukmu';

  @override
  String get postureLowConfidenceNote =>
      'Hasilnya kurang pasti, jadi saran tidak ditampilkan. Coba lagi dengan cahaya lebih baik dan seluruh tubuh dalam panduan.';

  @override
  String postureChange(String change) {
    return '$change sejak cek terakhir';
  }

  @override
  String postureFlaggedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hal untuk diperhatikan',
      one: '1 hal untuk diperhatikan',
      zero: 'Semua dalam rentang biasa',
    );
    return '$_temp0';
  }

  @override
  String valueDegrees(String value) {
    return '$value°';
  }

  @override
  String get exerciseSafetyNote =>
      'Ini ide mobilitas umum, bukan pengobatan. Berhenti jika ada yang sakit.';

  @override
  String get whyThis => 'Mengapa ini?';

  @override
  String whyObserved(String metric, String degrees, String band) {
    return '$metric terukur $degrees° ($band) pada cek ini.';
  }

  @override
  String get whyRepeated => 'Cek sebelumnya juga menunjukkan hal ini.';

  @override
  String get whyGoal => 'Postur adalah salah satu tujuanmu.';

  @override
  String get whyMaintenance =>
      'Semua perkiraan kelurusan dalam rentang biasa; jeda rutin membantu menjaganya.';

  @override
  String alternativeLabel(String name) {
    return 'Alternatif: $name';
  }

  @override
  String get poseAnalysisFailed =>
      'Gambar ini tidak dapat dianalisis di perangkat. Jika terus terjadi, mulai ulang kamera.';

  @override
  String get postureStepBack =>
      'Kembali ke dalam panduan — pengambilan dimulai ulang.';

  @override
  String postureCountdown(int seconds) {
    return 'Mulai dalam $seconds';
  }

  @override
  String get exerciseLibrary => 'Pustaka latihan';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterCameraTracked => 'Dengan kamera';

  @override
  String get cameraTracked => 'Dengan kamera';

  @override
  String get howTo => 'Cara melakukan';

  @override
  String get trackWithCamera => 'Pantau dengan kamera';

  @override
  String get logAsDone => 'Tandai selesai';

  @override
  String get savedToLog => 'Disimpan ke catatan latihanmu';

  @override
  String repsValue(int count) {
    return '$count repetisi';
  }

  @override
  String get trackingSetupFront =>
      'Sandarkan ponsel tegak setinggi pinggang, mundur 2–3 m, dan hadap kamera agar seluruh tubuh terlihat.';

  @override
  String get trackingSetupSide =>
      'Letakkan ponsel setinggi lantai atau pinggang di sampingmu agar seluruh tubuhmu terlihat dari samping.';

  @override
  String trackingTargetReps(int count) {
    return 'Target: $count repetisi';
  }

  @override
  String trackingTargetHold(int seconds) {
    return 'Target: tahan $seconds detik';
  }

  @override
  String get trackingReady =>
      'Siap — ketuk Mulai lalu ambil posisi selama hitung mundur.';

  @override
  String get trackingStart => 'Mulai';

  @override
  String get trackingFinish => 'Selesai';

  @override
  String trackingOfReps(int count) {
    return 'dari $count repetisi';
  }

  @override
  String trackingOfSeconds(int seconds) {
    return 'dari $seconds dtk';
  }

  @override
  String holdSecondsValue(int seconds) {
    return '$seconds dtk';
  }

  @override
  String get trackingSummaryTitle => 'Ringkasan sesi';

  @override
  String get trackingRepsDone => 'Repetisi terhitung';

  @override
  String get trackingHoldTime => 'Waktu dalam posisi';

  @override
  String get trackingTargetReached => 'Target tercapai — kerja bagus.';

  @override
  String get trackingCountNote =>
      'Dihitung oleh kamera ponsel ini. Sesekali bisa terlewat atau menambah satu repetisi.';

  @override
  String get saveToLog => 'Simpan ke catatan';

  @override
  String get trackingDone => 'Selesai';

  @override
  String get cueStepIntoView =>
      'Masuk ke bingkai agar seluruh tubuhmu terlihat.';

  @override
  String get cueGoLower => 'Turun sedikit lagi jika nyaman.';

  @override
  String get cueKneesOverToes => 'Jaga lutut sejajar dengan kaki.';

  @override
  String get cueChestUp => 'Tegakkan dada.';

  @override
  String get cueRaiseHigher => 'Angkat lengan sedikit lebih tinggi.';

  @override
  String get cueRaiseEvenly => 'Angkat kedua lengan sama tinggi.';

  @override
  String get cueLiftKneeHigher => 'Angkat lutut sedikit lebih tinggi.';

  @override
  String get cueKeepBodyStraight =>
      'Jaga garis lurus dari bahu ke pergelangan kaki.';

  @override
  String get cueGetIntoPosition => 'Ambil posisi.';

  @override
  String get cueGoodForm => 'Bagus — lanjutkan.';

  @override
  String get cueKeepGoing => 'Lanjutkan dengan tempo stabil.';

  @override
  String get faceHistory => 'Riwayat wajah';

  @override
  String get faceHistoryEmpty =>
      'Lakukan cek wajah untuk melihat saran gaya di sini.';

  @override
  String get faceIntro =>
      'Perkirakan bentuk wajahmu dari proporsinya dan dapatkan ide rambut, jenggot, kacamata, serta perawatan.';

  @override
  String get facePrivacy =>
      'Wajahmu dianalisis di ponsel ini. Tidak ada foto yang diambil atau disimpan; hanya proporsi yang disimpan, dan hanya jika kamu mengetuk Simpan.';

  @override
  String get faceTipLight =>
      'Hadap jendela atau lampu agar cahaya jatuh merata di wajah.';

  @override
  String get faceTipHair => 'Singkirkan rambut dari dahi dan garis rahang.';

  @override
  String get faceTipStraight =>
      'Lihat lurus ke kamera dengan ekspresi netral dan kepala tegak.';

  @override
  String get faceDisclaimer =>
      'Bentuk wajah adalah perkiraan kamera, hanya untuk ide gaya. Ini tidak menilai daya tarik, dan setiap wajah cocok dengan banyak gaya.';

  @override
  String get faceNone => 'Tidak ada wajah terdeteksi. Lihat ke kamera.';

  @override
  String get faceMultiple =>
      'Lebih dari satu wajah terlihat. Pastikan hanya kamu di bingkai.';

  @override
  String get faceModelRequired =>
      'Analisis wajah tidak tersedia di perangkat ini.';

  @override
  String get faceReady => 'Wajah terdeteksi — ketuk Analisis lalu diam.';

  @override
  String get faceTooFar => 'Dekatkan ponsel sedikit ke wajah.';

  @override
  String get faceTooClose => 'Jauhkan ponsel sedikit.';

  @override
  String get faceInGuide => 'Jaga seluruh wajah di dalam oval.';

  @override
  String get faceCapturing => 'Diam selagi beberapa gambar diukur…';

  @override
  String get faceNotReliable =>
      'Bentuk wajah tidak dapat diperkirakan dengan andal.';

  @override
  String get faceSaved => 'Cek wajah disimpan';

  @override
  String get faceResultTitle => 'Perkiraan bentuk wajah';

  @override
  String faceShapeBetween(String first, String second) {
    return '$first / $second';
  }

  @override
  String get faceLowConfidenceNote =>
      'Perkiraannya kurang pasti, jadi saran gaya tidak ditampilkan. Coba lagi dengan cahaya merata dan kepala tegak.';

  @override
  String get shapeOval => 'Oval';

  @override
  String get shapeRound => 'Bulat';

  @override
  String get shapeSquare => 'Persegi';

  @override
  String get shapeOblong => 'Lonjong';

  @override
  String get shapeHeart => 'Hati';

  @override
  String get shapeDiamond => 'Berlian';

  @override
  String get ratioLengthWidth => 'Panjang ÷ lebar tulang pipi';

  @override
  String get ratioForeheadCheek => 'Dahi ÷ lebar tulang pipi';

  @override
  String get ratioJawCheek => 'Rahang ÷ lebar tulang pipi';

  @override
  String get styleHair => 'Gaya rambut';

  @override
  String get styleBeard => 'Gaya jenggot';

  @override
  String get styleBeardNote => 'Jika kamu punya atau ingin rambut wajah.';

  @override
  String get styleGlasses => 'Bingkai kacamata';

  @override
  String get favoriteAdd => 'Tambah ke favorit';

  @override
  String get favoriteRemove => 'Hapus dari favorit';

  @override
  String get groomingTitle => 'Rutinitas perawatan sederhana';

  @override
  String get groomingAddRoutine => 'Tambahkan ke rutinitas saya';

  @override
  String get groomingRoutineName => 'Perawatan diri';

  @override
  String get groomingRoutineAdded =>
      'Rutinitas perawatan ditambahkan ke rutinitasmu';

  @override
  String faceBetweenNote(String shape) {
    return 'Proporsimu juga mendekati $shape, jadi ide untuk keduanya ditampilkan:';
  }

  @override
  String get cardFlipHint => 'Ketuk untuk detail';

  @override
  String get tryOn => 'Coba';

  @override
  String get tryOnOpen => 'Coba kacamata dan gaya jenggot';

  @override
  String get faceArtLegend => 'Abu-abu: bentuk acuan · Warna: proporsimu';

  @override
  String get tryOnHint =>
      'Tekan lama pratinjau untuk membandingkan tanpa gaya.';

  @override
  String get tryOnComparing => 'Menampilkan tanpa gaya';

  @override
  String get tryOnNone => 'Tidak ada';

  @override
  String get tryOnNote =>
      'Pratinjau langsung digambar di ponsel ini; tidak ada yang direkam. Jenggot berupa bayangan kasar, bukan gambar realistis.';

  @override
  String get featureProgressSnapshots => 'Foto kemajuan';

  @override
  String get snapFace => 'Wajah';

  @override
  String get snapBodyFront => 'Tubuh · depan';

  @override
  String get snapBodySide => 'Tubuh · samping';

  @override
  String get snapTake => 'Ambil foto';

  @override
  String get snapCompare => 'Bandingkan sebelum / sesudah';

  @override
  String get snapEmpty =>
      'Ambil foto pertamamu. Ulangi secara rutin di tempat dan cahaya yang sama untuk melihat perubahan.';

  @override
  String get snapPrivacyShort =>
      'Disimpan hanya di ponsel ini, di dalam basis data terenkripsi. Tidak pernah diunggah atau ditambahkan ke galeri.';

  @override
  String get snapLongPressDelete => 'Tekan lama foto untuk menghapusnya.';

  @override
  String get snapWeeklyReminder => 'Ingatkan saya setiap minggu (Minggu 09.00)';

  @override
  String get snapDeleteAll => 'Hapus semua foto';

  @override
  String get snapReminderRoutine => 'Foto kemajuan';

  @override
  String get snapReminderItem => 'Ambil foto kemajuan';

  @override
  String get snapReminderAdded =>
      'Pengingat foto mingguan ditambahkan ke rutinitasmu';

  @override
  String get snapConsentTitle => 'Pantau perubahan dengan foto pribadi';

  @override
  String get snapConsentStored =>
      'Foto hanya disimpan saat kamu mengetuk Simpan, di dalam basis data terenkripsi aplikasi ini.';

  @override
  String get snapConsentNeverUploaded =>
      'Foto tidak pernah keluar dari ponsel ini dan tidak ditambahkan ke galeri.';

  @override
  String get snapConsentOptIn =>
      'Ini opsional; semua fitur lain berfungsi tanpa foto.';

  @override
  String get snapConsentDelete =>
      'Kamu bisa menghapus foto mana pun, atau semuanya, kapan saja.';

  @override
  String get snapConsentAccept => 'Mengerti — aktifkan foto';

  @override
  String get snapGhost => 'Tampilkan foto terakhir sebagai panduan';

  @override
  String get snapGhostHelp =>
      'Sejajarkan dirimu dengan gambar samar agar foto bisa dibandingkan.';

  @override
  String get snapTipFace =>
      'Tempat dan cahaya yang sama setiap kali; lihat kamera dengan ekspresi netral.';

  @override
  String get snapTipBody =>
      'Sandarkan ponsel setinggi pinggang, mundur agar seluruh tubuh muat, dan pakai pakaian serupa setiap kali.';

  @override
  String get snapCapture => 'Ambil (penghitung 3 dtk)';

  @override
  String get snapSaveEncrypted => 'Simpan secara pribadi';

  @override
  String get snapSaved => 'Foto disimpan secara pribadi';

  @override
  String get snapBefore => 'Sebelum';

  @override
  String get snapAfter => 'Sesudah';

  @override
  String get snapCompareHelp =>
      'Geser di gambar untuk membandingkan. Pilih dua foto mana saja di bawah.';

  @override
  String get colourTitle => 'Warna & gaya';

  @override
  String get colourYourPalette => 'Paletmu';

  @override
  String get colourDisclaimer =>
      'Palet adalah saran teori warna, bukan aturan — pakai yang kamu suka.';

  @override
  String get quizVeinQ =>
      'Apa warna pembuluh darah di pergelangan tangan bagian dalam?';

  @override
  String get quizVeinHelp => 'Lihat di bawah cahaya siang tanpa filter.';

  @override
  String get quizVeinBlue => 'Biru atau ungu';

  @override
  String get quizVeinGreen => 'Kehijauan';

  @override
  String get quizVeinBoth => 'Sulit dibedakan / keduanya';

  @override
  String get quizJewelQ => 'Perhiasan apa yang paling cocok di kulitmu?';

  @override
  String get quizJewelHelp => 'Bayangkan cincin atau jam di tanganmu.';

  @override
  String get quizJewelSilver => 'Perak';

  @override
  String get quizJewelGold => 'Emas';

  @override
  String get quizJewelBoth => 'Keduanya cocok';

  @override
  String get quizSunQ =>
      'Bagaimana kulitmu biasanya bereaksi terhadap matahari?';

  @override
  String get quizSunHelp =>
      'Tanpa tabir surya, setelah sebentar di luar ruangan.';

  @override
  String get quizSunBurns => 'Terbakar atau memerah';

  @override
  String get quizSunTans => 'Mudah menjadi cokelat';

  @override
  String get quizSunBoth => 'Sedikit keduanya';

  @override
  String get quizDepthQ => 'Mana yang paling mendekati warna kulitmu?';

  @override
  String get quizDepthHelp => 'Ini menentukan seberapa kontras paletmu.';

  @override
  String get quizSeePalette => 'Lihat paletku';

  @override
  String get quizRetake => 'Ulangi kuis warna';

  @override
  String get undertoneWarm => 'Undertone hangat';

  @override
  String get undertoneCool => 'Undertone dingin';

  @override
  String get undertoneNeutral => 'Undertone netral';

  @override
  String get undertoneWarmExplain =>
      'Warna tanah, keemasan, dan zaitun cenderung serasi dengan kulitmu.';

  @override
  String get undertoneCoolExplain =>
      'Warna permata, biru, dan merah muda cenderung serasi dengan kulitmu.';

  @override
  String get undertoneNeutralExplain =>
      'Sebagian besar warna seimbang cocok untukmu; hindari hanya warna yang sangat ekstrem di dekat wajah.';

  @override
  String get depthLight => 'Terang';

  @override
  String get depthMedium => 'Sedang';

  @override
  String get depthDeep => 'Gelap';

  @override
  String get paletteBest => 'Warna terbaik';

  @override
  String get paletteBestNote =>
      'Pakai di dekat wajah — atasan, kemeja, syal. Ketuk satu untuk mencobanya.';

  @override
  String get paletteNeutrals => 'Warna netralmu';

  @override
  String get paletteNeutralsNote =>
      'Warna dasar untuk celana, luaran, dan sepatu.';

  @override
  String get paletteSparingly => 'Pakai secukupnya';

  @override
  String get paletteSparinglyNote =>
      'Cocok jauh dari wajah atau sebagai aksen kecil.';

  @override
  String get drapeOpen => 'Coba warna secara langsung';

  @override
  String get drapeTitle => 'Uji warna';

  @override
  String get drapeHint => 'Ketuk warna di bawah dan bandingkan';

  @override
  String get drapeNote =>
      'Uji warna menunjukkan bagaimana suatu warna terlihat di samping wajahmu. Hanya pratinjau langsung; tidak ada yang direkam. Cahaya ruangan memengaruhi tampilan warna.';

  @override
  String get stylePrefsTitle => 'Gaya yang kamu suka';

  @override
  String get prefClassic => 'Klasik';

  @override
  String get prefMinimal => 'Minimalis';

  @override
  String get prefSmartCasual => 'Smart casual';

  @override
  String get prefStreet => 'Streetwear';

  @override
  String get prefTraditional => 'Tradisional / etnik';

  @override
  String get prefSporty => 'Sporty';

  @override
  String get wardrobeAdd => 'Tambah pakaian';

  @override
  String get wardrobeEmpty =>
      'Tambahkan beberapa pakaian yang sering kamu pakai — atasan, bawahan, dan sepatu — lalu dapatkan ide padu padan dari pakaianmu sendiri.';

  @override
  String get wardrobePrivacy =>
      'Foto pakaian tetap di ponsel ini di dalam basis data terenkripsi.';

  @override
  String get outfitIdeas => 'Ide padu padan';

  @override
  String get outfitIdeasTab => 'Ide';

  @override
  String get outfitSavedTab => 'Tersimpan';

  @override
  String get outfitNone =>
      'Belum ada kombinasi untuk acara ini. Tambahkan atasan, bawahan, dan sepatu, atau tandai pakaian untuk acara ini.';

  @override
  String get outfitPaletteHint =>
      'Tips: selesaikan kuis warna untuk mengurutkan padu padan sesuai paletmu.';

  @override
  String get outfitSave => 'Simpan padu padan';

  @override
  String get outfitSavedEmpty =>
      'Padu padan tersimpan muncul di sini, siap untuk pagi yang sibuk.';

  @override
  String get outfitWoreToday => 'Dipakai hari ini';

  @override
  String get garmentName => 'Nama (mis. kemeja oxford putih)';

  @override
  String get garmentPhoto => 'Tambah foto (opsional)';

  @override
  String get garmentRetakePhoto => 'Ambil ulang foto';

  @override
  String get garmentPhotoTip =>
      'Bentangkan atau gantung pakaian di tempat terang hingga memenuhi bingkai. Warna dibaca dari bagian tengah.';

  @override
  String get garmentCategory => 'Jenis';

  @override
  String get garmentColour => 'Warna';

  @override
  String get garmentColourFromPhoto =>
      'Warna (dibaca dari foto — sesuaikan bila perlu)';

  @override
  String get garmentPattern => 'Motif';

  @override
  String get garmentFormality => 'Formalitas';

  @override
  String get garmentOccasions => 'Acara';

  @override
  String get garmentOccasionsHelp => 'Kosongkan untuk semua acara.';

  @override
  String get catTop => 'Atasan / kemeja';

  @override
  String get catBottom => 'Bawahan';

  @override
  String get catOnePiece => 'Gaun / terusan';

  @override
  String get catOuterwear => 'Luaran';

  @override
  String get catFootwear => 'Alas kaki';

  @override
  String get catEthnicTop => 'Kurta / atasan etnik';

  @override
  String get catEthnicBottom => 'Bawahan etnik';

  @override
  String get catAccessory => 'Aksesori';

  @override
  String get patSolid => 'Polos';

  @override
  String get patStripes => 'Garis';

  @override
  String get patChecks => 'Kotak';

  @override
  String get patPrint => 'Cetak';

  @override
  String get occCasual => 'Santai';

  @override
  String get occWork => 'Kerja';

  @override
  String get occFormal => 'Formal';

  @override
  String get occFestive => 'Perayaan';

  @override
  String get occSport => 'Olahraga';

  @override
  String get form1 => 'Sangat santai';

  @override
  String get form2 => 'Santai';

  @override
  String get form3 => 'Rapi';

  @override
  String get form4 => 'Necis';

  @override
  String get form5 => 'Formal';

  @override
  String get reasonAllNeutral => 'Semua warna netral — mudah dan rapi.';

  @override
  String get reasonOneAccent => 'Satu warna aksen di antara warna netral.';

  @override
  String get reasonTonal => 'Warna senada dari keluarga yang sama.';

  @override
  String get reasonAnalogous => 'Warna berdekatan yang menyatu mulus.';

  @override
  String get reasonComplementary =>
      'Warna berlawanan untuk kontras yang percaya diri.';

  @override
  String get reasonInPalette => 'Warna di dekat wajahmu ada di paletmu.';

  @override
  String get reasonOnePattern => 'Satu motif, diimbangi warna polos.';

  @override
  String get reasonMatchedFormality => 'Setiap pakaian sesuai acaranya.';

  @override
  String get reasonFavourite => 'Termasuk pakaian favorit.';

  @override
  String get reasonNotWorn => 'Tidak ada yang dipakai minggu ini.';

  @override
  String outfitWornCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dipakai $count kali',
      one: 'Dipakai sekali',
      zero: 'Belum dipakai',
    );
    return '$_temp0';
  }

  @override
  String get journeyTitle => 'Perjalananmu';

  @override
  String journeyLevel(int level) {
    return 'Level $level';
  }

  @override
  String journeyXpToNext(int xp, int level) {
    return '$xp XP menuju level $level';
  }

  @override
  String journeyTodayXp(int xp) {
    return '+$xp XP hari ini';
  }

  @override
  String journeyStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Runtutan $count hari',
      one: 'Runtutan 1 hari',
      zero: 'Belum ada runtutan',
    );
    return '$_temp0';
  }

  @override
  String journeyRestDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari istirahat tersimpan',
      one: '1 hari istirahat tersimpan',
      zero: 'Belum ada hari istirahat tersimpan',
    );
    return '$_temp0';
  }

  @override
  String get journeyRestDaysHelp =>
      'Setiap 7 hari aktif memberi satu hari istirahat. Hari yang terlewat memakai satu, jadi runtutanmu berlanjut.';

  @override
  String get journeyStartTimelapse =>
      'Ambil foto wajah untuk memulai time-lapse-mu';

  @override
  String get journeyOneSnapshot =>
      'Tambahkan foto lagi minggu depan untuk melihat perubahanmu';

  @override
  String journeySnapshotCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foto',
      one: '1 foto',
    );
    return '$_temp0';
  }

  @override
  String get journeyFirst => 'Pertama';

  @override
  String get journeyLatest => 'Terbaru';

  @override
  String get journeyPlay => 'Putar time-lapse';

  @override
  String get journeyPause => 'Jeda';

  @override
  String get journeyCompare => 'Bandingkan berdampingan';

  @override
  String get journeyAlignNote =>
      'Foto disejajarkan berdasarkan mata. Foto menghadap depan yang terang paling pas.';

  @override
  String get journeyTotalXp => 'Total XP';

  @override
  String get journeyBestStreak => 'Runtutan terbaik';

  @override
  String get journeyActiveDays => 'Hari aktif';

  @override
  String get journeyLast4Weeks => '4 minggu terakhir';

  @override
  String get journeyTrends => 'Tren';

  @override
  String get journeyWeight => 'Berat badan';

  @override
  String get journeyXpPerDay => 'XP per hari';

  @override
  String get journeyBadges => 'Lencana';

  @override
  String journeyBadgesEarned(int earned, int total) {
    return '$earned dari $total diraih';
  }

  @override
  String get journeyHowXp => 'Cara kerja XP';

  @override
  String get journeyHowXpBody =>
      'XP berasal dari yang sudah kamu catat — air, makan, tidur, aktivitas, kebiasaan, item rencana, cek, foto, dan padu padan. Hari dengan 15 XP atau lebih dihitung dalam runtutanmu. Melewatkan hari tidak pernah mengurangi XP.';

  @override
  String get questsTitle => 'Misi hari ini';

  @override
  String questsReward(int xp) {
    return '+$xp XP';
  }

  @override
  String questsAllDone(int xp) {
    return 'Semua selesai — bonus +$xp XP';
  }

  @override
  String questsAllBonus(int xp) {
    return 'Selesaikan ketiganya untuk bonus +$xp XP';
  }

  @override
  String get questDrinkTarget => 'Capai target minummu';

  @override
  String get questLogMeals => 'Catat dua kali makan';

  @override
  String get questPostureCheck => 'Lakukan cek postur';

  @override
  String get questCompletePlan => 'Selesaikan tiga item rencana';

  @override
  String get questAllHabits => 'Selesaikan kebiasaan hari ini';

  @override
  String get questLogSleep => 'Catat tidur semalam';

  @override
  String get questWorkout => 'Catat latihan atau aktivitas';

  @override
  String get questWearOutfit => 'Pakai padu padan tersimpan';

  @override
  String get questSnapshot => 'Ambil foto wajah minggu ini';

  @override
  String get questLogWeight => 'Catat berat badanmu';

  @override
  String get badgeUnlocked => 'Lencana terbuka';

  @override
  String badgesUnlocked(int count) {
    return '$count lencana terbuka';
  }

  @override
  String get badgeContinue => 'Lanjut';

  @override
  String badgeProgress(int progress, int target) {
    return '$progress / $target';
  }

  @override
  String get badgeFirstSteps => 'Langkah pertama';

  @override
  String get badgeFirstStepsInfo => 'Catat apa pun untuk pertama kali.';

  @override
  String get badgeStreak7 => 'Seminggu konsisten';

  @override
  String get badgeStreak7Info => 'Capai runtutan 7 hari.';

  @override
  String get badgeStreak30 => 'Tiga puluh hari kuat';

  @override
  String get badgeStreak30Info => 'Capai runtutan 30 hari.';

  @override
  String get badgeHydration => 'Terhidrasi baik';

  @override
  String get badgeHydrationInfo => 'Capai target minum selama 7 hari.';

  @override
  String get badgePosture => 'Rajin cek postur';

  @override
  String get badgePostureInfo => 'Selesaikan 5 cek postur.';

  @override
  String get badgeFace => 'Penjelajah wajah';

  @override
  String get badgeFaceInfo => 'Selesaikan analisis wajah.';

  @override
  String get badgeJourney => 'Penjaga perjalanan';

  @override
  String get badgeJourneyInfo => 'Simpan 4 foto kemajuan.';

  @override
  String get badgePlanner => 'Perencana';

  @override
  String get badgePlannerInfo => 'Selesaikan 20 item rencana.';

  @override
  String get badgeHabits => 'Pembangun kebiasaan';

  @override
  String get badgeHabitsInfo => 'Selesaikan kebiasaan 30 kali.';

  @override
  String get badgeStylist => 'Penata gaya';

  @override
  String get badgeStylistInfo => 'Simpan 5 padu padan.';

  @override
  String get badgeLevel5 => 'Level 5';

  @override
  String get badgeLevel5Info => 'Capai level 5.';

  @override
  String get badgeLevel10 => 'Level 10';

  @override
  String get badgeLevel10Info => 'Capai level 10.';

  @override
  String get forYouTitle => 'Untukmu hari ini';

  @override
  String get forYouSnapshot => 'Foto mingguan';

  @override
  String get forYouSnapshotInfo => 'Tambahkan bingkai ke time-lapse-mu';

  @override
  String get forYouTryOn => 'Coba tampilan baru';

  @override
  String get forYouTryOnInfo => 'Kacamata dan jenggot, langsung di wajahmu';

  @override
  String get forYouPosture => 'Cek postur';

  @override
  String get forYouPostureInfo => 'Dua menit, tips untukmu';

  @override
  String get forYouColours => 'Temukan warnamu';

  @override
  String get forYouColoursInfo => 'Kuis singkat untuk paletmu';

  @override
  String get forYouOutfit => 'Padu padan hari ini';

  @override
  String get forYouOutfitInfo => 'Ide dari lemarimu';

  @override
  String get forYouFace => 'Bentuk wajah';

  @override
  String get forYouFaceInfo => 'Gaya yang cocok untukmu';

  @override
  String get forYouExercise => 'Bergerak sedikit';

  @override
  String get forYouExerciseInfo => 'Repetisi terpandu, dihitung langsung';

  @override
  String get forYouHairstyles => 'Ide gaya rambut';

  @override
  String get forYouHairstylesInfo => 'Dipilih untuk bentuk wajahmu';

  @override
  String get goalFinderTitle => 'Temukan fokusmu';

  @override
  String get goalFinderStep1 => 'Apa yang ingin kamu tingkatkan?';

  @override
  String get goalFinderStep1Hint => 'Ketuk setiap gambar yang menarik bagimu.';

  @override
  String get goalFinderStep2 => 'Gaya mana yang terasa seperti dirimu?';

  @override
  String get goalFinderStep2Hint =>
      'Pilih sebanyak yang kamu mau — ini membentuk ide padu padanmu.';

  @override
  String get goalFinderNext => 'Berikutnya';

  @override
  String get goalFinderBack => 'Kembali';

  @override
  String get goalFinderSave => 'Simpan fokusku';

  @override
  String get goalFinderSaved =>
      'Fokusmu tersimpan. Misi dan saran kini mengikutinya.';

  @override
  String goalFinderSelected(int count) {
    return '$count dipilih';
  }

  @override
  String get forYouGoals => 'Apa yang kamu inginkan?';

  @override
  String get forYouGoalsInfo => 'Pilih gambar yang menginspirasimu';

  @override
  String get profileGender => 'Gender';

  @override
  String get profileGenderHelp =>
      'Hanya dipakai untuk perkiraan kalori dan menampilkan contoh gaya yang relevan.';

  @override
  String get genderMale => 'Laki-laki';

  @override
  String get genderFemale => 'Perempuan';

  @override
  String get genderNonBinary => 'Non-biner';

  @override
  String get genderPreferNot => 'Memilih tidak menyebutkan';

  @override
  String get profileDiet => 'Preferensi makanan';

  @override
  String get dietVegetarian => 'Vegetarian';

  @override
  String get dietEggetarian => 'Vegetarian dengan telur';

  @override
  String get dietNonVegetarian => 'Non-vegetarian';

  @override
  String get dietVegan => 'Vegan';

  @override
  String get profileStyleFit => 'Tampilkan contoh gaya untuk';

  @override
  String get styleFitAuto => 'Sesuai gender saya';

  @override
  String get styleFitMenswear => 'Busana pria';

  @override
  String get styleFitWomenswear => 'Busana wanita';

  @override
  String get styleFitAll => 'Semua';

  @override
  String get onboardingAboutTitle => 'Tentang kamu';

  @override
  String get onboardingAboutBody =>
      'Semua di sini opsional dan tetap di ponsel ini. Ini menyesuaikan rencana, misi, dan saran gayamu.';

  @override
  String get onboardingHeightCm => 'Tinggi (cm)';

  @override
  String get onboardingHeightFt => 'Tinggi (ft)';

  @override
  String get onboardingHeightIn => 'in';

  @override
  String get onboardingWeightKg => 'Berat (kg)';

  @override
  String get onboardingWeightLb => 'Berat (lb)';

  @override
  String get onboardingInvalid => 'Periksa nilai ini';

  @override
  String get greetingMorning => 'Selamat pagi';

  @override
  String get greetingAfternoon => 'Selamat siang';

  @override
  String get greetingEvening => 'Selamat malam';

  @override
  String greetingNamed(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeCompleteProfile => 'Sesuaikan aplikasimu';

  @override
  String get homeCompleteProfileInfo =>
      'Tambahkan gender, tinggi, dan berat untuk rencana yang akurat dan gaya yang relevan.';

  @override
  String get forYouBodyPlan => 'Rencana dietmu';

  @override
  String get forYouBodyPlanInfo => 'Makan dan latihan untuk tujuanmu';

  @override
  String get featureBodyPlan => 'Rencana diet & tubuh';

  @override
  String get bodyPlanIntro =>
      'Target kalori dan protein, menu harian, dan minggu latihan sederhana, berdasarkan tinggi, berat, dan tujuanmu.';

  @override
  String get bodyPlanNeedData =>
      'Tambahkan tinggi dan berat untuk membuat rencana.';

  @override
  String get bodyPlanImprove =>
      'Tambahkan gender, rentang usia, dan tingkat aktivitas di Profil untuk perkiraan yang lebih baik.';

  @override
  String get bodyPlanOpenProfile => 'Buka profil';

  @override
  String get bodyPlanGoal => 'Tujuanmu';

  @override
  String get planLoseFat => 'Turunkan lemak';

  @override
  String get planMaintain => 'Tetap bugar';

  @override
  String get planGainWeight => 'Naikkan berat';

  @override
  String get planBuildMuscle => 'Bangun otot';

  @override
  String get planLoseFatInfo => 'Defisit kalori sedang dengan protein tinggi';

  @override
  String get planMaintainInfo => 'Makan sesuai kebutuhan dan berlatih rutin';

  @override
  String get planGainWeightInfo =>
      'Surplus stabil untuk menaikkan berat secara sehat';

  @override
  String get planBuildMuscleInfo => 'Surplus ringan dengan latihan kekuatan';

  @override
  String get planBlockUnderage =>
      'Di bawah 18 tahun: rencanakan perubahan berat bersama dokter. Panduan pemeliharaan tersedia.';

  @override
  String get planBlockUnderweight =>
      'BMI-mu di bawah 18,5, jadi penurunan lemak tidak disarankan.';

  @override
  String get planBlockHeavy =>
      'BMI-mu 25 atau lebih. Coba Bangun otot sebagai gantinya.';

  @override
  String get bodyPlanPace => 'Laju';

  @override
  String get paceGentle => 'Pelan';

  @override
  String get paceSteady => 'Stabil';

  @override
  String get paceBrisk => 'Cepat';

  @override
  String bodyPlanRate(String rate) {
    return 'Sekitar $rate per minggu';
  }

  @override
  String get bodyPlanTarget => 'Berat target (opsional)';

  @override
  String bodyPlanHealthyRange(String range) {
    return 'Rentang sehat untuk tinggimu: $range';
  }

  @override
  String get bodyPlanCalories => 'Kalori';

  @override
  String get bodyPlanProtein => 'Protein';

  @override
  String get bodyPlanCarbs => 'Karbohidrat';

  @override
  String get bodyPlanFat => 'Lemak';

  @override
  String get bodyPlanWater => 'Air';

  @override
  String bodyPlanKcal(int value) {
    return '$value kkal';
  }

  @override
  String bodyPlanGrams(int value) {
    return '$value g';
  }

  @override
  String bodyPlanMaintenance(int kcal) {
    return 'Kebutuhan pemeliharaan sekitar $kcal kkal per hari';
  }

  @override
  String bodyPlanTimeline(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: 'Sekitar $weeks minggu menuju targetmu',
      one: 'Sekitar 1 minggu menuju targetmu',
    );
    return '$_temp0';
  }

  @override
  String get bodyPlanFloorNote =>
      'Dijaga pada batas minimum yang aman, jadi kemajuan akan lebih lambat dari laju ini.';

  @override
  String get bodyPlanStart => 'Mulai rencanaku';

  @override
  String get bodyPlanStarted => 'Rencanamu sudah dimulai';

  @override
  String get bodyPlanDisclaimer =>
      'Perkiraan untuk orang dewasa sehat, bukan nasihat medis. Jika kamu punya kondisi medis, sedang hamil, atau minum obat, tanyakan dokter dulu.';

  @override
  String bodyPlanSince(String date) {
    return 'Sejak $date';
  }

  @override
  String get bodyPlanToday => 'Target hari ini';

  @override
  String bodyPlanEaten(int eaten, int target) {
    return '$eaten dari $target kkal tercatat hari ini';
  }

  @override
  String get bodyPlanMenu => 'Menu hari ini';

  @override
  String bodyPlanServings(String servings) {
    return '× $servings';
  }

  @override
  String get bodyPlanProteinBoost => 'Tambahan protein';

  @override
  String get bodyPlanLog => 'Catat';

  @override
  String get bodyPlanLogged => 'Tercatat';

  @override
  String get bodyPlanSwap => 'Tukar';

  @override
  String get bodyPlanWeek => 'Latihan minggu ini';

  @override
  String get workoutStrengthA => 'Kekuatan A';

  @override
  String get workoutStrengthB => 'Kekuatan B';

  @override
  String get workoutCardio => 'Kardio';

  @override
  String get workoutMobility => 'Mobilitas';

  @override
  String get workoutRest => 'Istirahat';

  @override
  String bodyPlanMinutes(int minutes) {
    return '$minutes mnt';
  }

  @override
  String bodyPlanTodayWorkout(String workout) {
    return 'Hari ini: $workout';
  }

  @override
  String get bodyPlanAddRoutine => 'Tambahkan latihan ke rutinitasku';

  @override
  String get bodyPlanRoutineAdded => 'Ditambahkan ke rutinitasmu';

  @override
  String get bodyPlanRoutineName => 'Rencana latihan';

  @override
  String get bodyPlanWorkoutItem => 'Latihan';

  @override
  String get bodyPlanProgress => 'Kemajuan';

  @override
  String bodyPlanWeightNow(String now, String start) {
    return '$now sekarang · mulai dari $start';
  }

  @override
  String bodyPlanExpected(String weight) {
    return 'Perkiraan saat ini: $weight';
  }

  @override
  String get bodyPlanUpdate => 'Beratmu berubah. Perbarui targetmu?';

  @override
  String get bodyPlanUpdateAction => 'Perbarui';

  @override
  String get bodyPlanEnd => 'Akhiri rencana';

  @override
  String get bodyPlanEndConfirm =>
      'Akhiri rencana ini? Catatan makan dan latihanmu tetap tersimpan.';

  @override
  String get bodyPlanLogWeight => 'Catat berat';

  @override
  String get bodyPlanChange => 'Ubah rencana';

  @override
  String get profileRegion => 'Kamu tinggal di mana?';

  @override
  String get profileRegionHelp =>
      'Dipakai untuk menyarankan makanan lokal, olahraga yang sesuai, dan tips iklim.';

  @override
  String get regionIndiaNorth => 'India Utara';

  @override
  String get regionIndiaSouth => 'India Selatan';

  @override
  String get regionIndiaEast => 'India Timur';

  @override
  String get regionIndiaWest => 'India Barat';

  @override
  String get regionSouthAsia => 'Asia Selatan lainnya';

  @override
  String get regionEastAsia => 'Asia Timur';

  @override
  String get regionSoutheastAsia => 'Asia Tenggara';

  @override
  String get regionMiddleEast => 'Timur Tengah';

  @override
  String get regionAfrica => 'Afrika';

  @override
  String get regionEurope => 'Eropa';

  @override
  String get regionNorthAmerica => 'Amerika Utara';

  @override
  String get regionLatinAmerica => 'Amerika Latin';

  @override
  String get regionOceania => 'Oseania';

  @override
  String get bodyPlanHotClimate =>
      'Iklim hangat: berlatih pagi atau sore saat lebih sejuk, dan minum air sepanjang hari.';

  @override
  String bodyPlanLocalMenu(String region) {
    return 'Menu dipilih dari masakan $region bila memungkinkan.';
  }

  @override
  String get dailyPlan => 'Rencana harian';

  @override
  String get partMorning => 'Pagi';

  @override
  String get partAfternoon => 'Siang';

  @override
  String get partEvening => 'Malam';

  @override
  String get partAnytime => 'Kapan saja';

  @override
  String agendaWater(String target) {
    return 'Minum $target';
  }

  @override
  String agendaWorkout(String workout, int minutes) {
    return '$workout · $minutes mnt';
  }

  @override
  String agendaOptional(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opsional hari ini',
      one: '1 opsional hari ini',
    );
    return '$_temp0';
  }

  @override
  String get agendaMissed => 'Terlewat';

  @override
  String get agendaReschedule => 'Jadwalkan ulang';

  @override
  String get agendaSkip => 'Lewati hari ini';

  @override
  String get agendaDone => 'Tandai selesai';

  @override
  String get agendaUndo => 'Urungkan';

  @override
  String agendaLookingBack(String date) {
    return 'Melihat kembali $date';
  }

  @override
  String get agendaEmpty =>
      'Belum ada rencana. Tambahkan rutinitas, kebiasaan, atau rencana diet untuk menyusun harimu.';

  @override
  String agendaProgress(int done, int total) {
    return '$done dari $total selesai';
  }

  @override
  String get dayModeTitle => 'Bagaimana hari ini?';

  @override
  String get dayModeNormal => 'Normal';

  @override
  String get dayModeBusy => 'Sibuk';

  @override
  String get dayModeLow => 'Energi rendah';

  @override
  String get dayModeNormalInfo => 'Rencana lengkapmu.';

  @override
  String get dayModeBusyInfo => 'Hanya yang penting, dengan latihan 5 menit.';

  @override
  String get dayModeLowInfo =>
      'Mobilitas ringan sebagai ganti latihan. Istirahat juga dihitung.';

  @override
  String get moodTitle => 'Cek suasana hati';

  @override
  String get moodQuestion => 'Bagaimana perasaanmu?';

  @override
  String get energyQuestion => 'Tingkat energi';

  @override
  String get mood1 => 'Buruk';

  @override
  String get mood2 => 'Biasa';

  @override
  String get mood3 => 'Oke';

  @override
  String get mood4 => 'Baik';

  @override
  String get mood5 => 'Hebat';

  @override
  String get energy1 => 'Lelah';

  @override
  String get energy2 => 'Rendah';

  @override
  String get energy3 => 'Stabil';

  @override
  String get energy4 => 'Baik';

  @override
  String get energy5 => 'Tinggi';

  @override
  String get moodSave => 'Simpan';

  @override
  String get moodSaved => 'Terima kasih sudah berbagi';

  @override
  String get moodSuggestLow => 'Energimu rendah hari ini. Jadikan hari santai?';

  @override
  String get moodSwitch => 'Ganti';

  @override
  String moodToday(String mood, String energy) {
    return 'Hari ini: $mood · energi $energy';
  }

  @override
  String get fiveTitle => 'Punya 5 menit?';

  @override
  String get fiveWater => 'Minum segelas air';

  @override
  String get fiveWaterInfo => 'Minummu sedikit tertinggal untuk jam segini.';

  @override
  String fiveHabit(String habit) {
    return 'Lakukan sekarang: $habit';
  }

  @override
  String get fiveHabitInfo => 'Satu kebiasaan, selesai dalam beberapa menit.';

  @override
  String get fiveMobility => 'Mobilitas 5 menit';

  @override
  String get fiveMobilityInfo => 'Leher, bahu, dan postur: penyegaran cepat.';

  @override
  String get fiveOutfit => 'Rencanakan padu padan besok';

  @override
  String get fiveOutfitInfo => 'Pilih malam ini, berpikir lebih sedikit besok.';

  @override
  String get fivePosture => 'Cek postur cepat';

  @override
  String get fivePostureInfo => 'Dua menit dengan kamera, tips untukmu.';

  @override
  String get fiveDo => 'Lakukan';

  @override
  String get quickAdd => 'Tambah cepat';

  @override
  String quickWater(int ml) {
    return '+$ml ml air';
  }

  @override
  String get quickMeal => 'Catat makan';

  @override
  String get quickWeight => 'Catat berat';

  @override
  String get quickSleep => 'Catat tidur';

  @override
  String get quickMood => 'Suasana hati';

  @override
  String get quickAdded => 'Ditambahkan';

  @override
  String get remindersQuiet => 'Jam tenang';

  @override
  String remindersQuietInfo(String start, String end) {
    return 'Tanpa pengingat dari $start sampai $end. Item tetap ada di rencanamu.';
  }

  @override
  String get remindersQuietOff => 'Mati: pengingat bisa datang kapan saja.';

  @override
  String get insightsTitle => 'Wawasan';

  @override
  String get insightsIntro =>
      'Rencana dibandingkan yang benar-benar terjadi. Hari tanpa catatan tampil sebagai tanpa data, bukan sebagai gagal.';

  @override
  String get insightsHomeInfo => 'Rencana vs kenyataan, skor tidur, dan tren';

  @override
  String get rangeWeek => 'Minggu';

  @override
  String get rangeMonth => 'Bulan';

  @override
  String get metricPlan => 'Item rencana';

  @override
  String get metricHabits => 'Kebiasaan';

  @override
  String get metricWater => 'Air';

  @override
  String get metricSleep => 'Tidur';

  @override
  String get metricActivity => 'Menit aktif';

  @override
  String get metricMeals => 'Makan tercatat';

  @override
  String get metricMood => 'Suasana hati';

  @override
  String insightsMet(int met, int logged) {
    return 'Tercapai pada $met dari $logged hari tercatat';
  }

  @override
  String insightsLogged(int logged) {
    return 'Tercatat pada $logged hari';
  }

  @override
  String get insightsNoData => 'Belum ada catatan di periode ini.';

  @override
  String insightsAverage(String value) {
    return 'Rata-rata $value';
  }

  @override
  String insightsUp(String value, String period) {
    return 'Naik $value dibanding $period sebelumnya';
  }

  @override
  String insightsDown(String value, String period) {
    return 'Turun $value dibanding $period sebelumnya';
  }

  @override
  String insightsSame(String period) {
    return 'Sama dengan $period sebelumnya';
  }

  @override
  String get insightsPeriodWeek => 'minggu';

  @override
  String get insightsPeriodMonth => 'bulan';

  @override
  String get legendMet => 'Tercapai';

  @override
  String get legendPartial => 'Sebagian';

  @override
  String get legendMissed => 'Tidak tercapai';

  @override
  String get legendNoData => 'Tanpa data';

  @override
  String get sleepScoreTitle => 'Skor tidur';

  @override
  String get sleepScoreInfo =>
      'Dari waktu tidur dan bangun yang kamu catat selama 7 malam terakhir: durasi (70 poin) dan keteraturan (30). Tanpa tahap tidur; itu perlu perangkat wearable.';

  @override
  String sleepAverage(String value) {
    return 'Rata-rata $value per malam';
  }

  @override
  String sleepSpread(int minutes) {
    return 'Waktu tidur bervariasi sekitar $minutes mnt';
  }

  @override
  String sleepNights(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count malam tercatat',
      one: '1 malam tercatat',
    );
    return '$_temp0';
  }

  @override
  String get sleepExcellent => 'Sangat baik';

  @override
  String get sleepGood => 'Baik';

  @override
  String get sleepFair => 'Cukup';

  @override
  String get sleepCare => 'Perlu perhatian';

  @override
  String get sleepScoreEmpty =>
      'Catat tidur beberapa malam untuk melihat skormu.';

  @override
  String get evolutionTitle => 'Evolusi';

  @override
  String get evolutionIntro =>
      'Momen di sepanjang perjalananmu, dari yang telah kamu lakukan. Tambahkan juga catatanmu.';

  @override
  String get evolutionEmpty =>
      'Pencapaianmu akan muncul di sini seiring kamu memakai aplikasi.';

  @override
  String get evolutionAddNote => 'Tambah catatan';

  @override
  String get evolutionNoteHint => 'Apa yang berubah, bagaimana perasaanmu…';

  @override
  String get evolutionSeeAll => 'Lihat semua';

  @override
  String get msFirstStep => 'Langkah pertama: kamu mencatat sesuatu';

  @override
  String get msFirstPosture => 'Cek postur pertama';

  @override
  String get msFirstFace => 'Analisis wajah pertama';

  @override
  String get msFirstSnapshot => 'Foto kemajuan pertama';

  @override
  String get msFirstOutfit => 'Padu padan pertama disimpan';

  @override
  String msPlanStarted(String plan) {
    return 'Memulai rencana: $plan';
  }

  @override
  String get msStreak7 => 'Mencapai runtutan 7 hari';

  @override
  String get msStreak30 => 'Mencapai runtutan 30 hari';

  @override
  String get msHabits30 => '30 kebiasaan diselesaikan';

  @override
  String msWeightDown(String value) {
    return 'Turun $value sejak timbangan pertama';
  }

  @override
  String msWeightUp(String value) {
    return 'Naik $value sejak timbangan pertama';
  }

  @override
  String get reviewTitle => 'Minggumu';

  @override
  String reviewWeekOf(String date) {
    return 'Minggu $date';
  }

  @override
  String reviewActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari aktif',
      one: '1 hari aktif',
    );
    return '$_temp0';
  }

  @override
  String reviewWater(int met) {
    return 'Target minum tercapai $met hari';
  }

  @override
  String reviewSleep(String value) {
    return 'Rata-rata tidur $value';
  }

  @override
  String reviewActivity(int count) {
    return 'Aktif $count hari';
  }

  @override
  String reviewBest(String day) {
    return 'Hari terbaik: $day';
  }

  @override
  String get reviewTipPlan =>
      'Minggu depan: pindahkan item rencana ke waktu yang lebih cocok dengan harimu.';

  @override
  String get reviewTipHabits =>
      'Minggu depan: buat kebiasaan kecil. Satu yang tak pernah terlewat lebih baik dari tiga yang dilewati.';

  @override
  String get reviewTipWater =>
      'Minggu depan: taruh botol di tempat terlihat dan minum segelas setiap makan.';

  @override
  String get reviewTipSleep =>
      'Minggu depan: usahakan jam tidur teratur, termasuk akhir pekan.';

  @override
  String get reviewTipActivity =>
      'Minggu depan: jalan kaki 10 menit setelah makan sudah dihitung.';

  @override
  String get reviewTipMeals =>
      'Minggu depan: mencatat makan membantu rencanamu lebih pas.';

  @override
  String get reviewTipKeep =>
      'Minggu depan: pertahankan ritme yang sudah kamu bangun.';

  @override
  String get reviewClose => 'Tutup';

  @override
  String get reviewSeeInsights => 'Lihat wawasan';

  @override
  String get postureCompare => 'Bandingkan';

  @override
  String get postureCompareTitle => 'Bandingkan sesi';

  @override
  String get postureCompareSetup =>
      'Agar perbandingan adil, gunakan pengaturan yang sama: tempat dan jarak sama, cahaya serupa, pakaian pas badan, dan waktu yang mirip.';

  @override
  String get postureCompareEarlier => 'Sebelumnya';

  @override
  String get postureCompareLater => 'Sesudahnya';

  @override
  String get postureCompareChange => 'Perubahan';

  @override
  String get postureCompareNeedTwo =>
      'Simpan dua cek dengan tampilan yang sama untuk membandingkannya.';

  @override
  String get connectedTitle => 'Data terhubung';

  @override
  String get connectedIntro =>
      'Pantau langkah, jalan, lari, dan tidur dari sensor ponsel ini. Semua tetap di perangkat ini: tanpa akun, tanpa cloud, tidak ada yang diunggah.';

  @override
  String get connectedPhoneSensors => 'Sensor ponsel ini';

  @override
  String get connectedSteps => 'Langkah';

  @override
  String get connectedStepsInfo =>
      'Dihitung oleh sensor langkah ponsel, diperiksa setiap 15 menit.';

  @override
  String get connectedActivity => 'Jalan, lari, dan bersepeda';

  @override
  String get connectedActivityInfo =>
      'Terdeteksi di ponsel saat kamu bergerak 10 menit atau lebih.';

  @override
  String get connectedSleep => 'Waktu tidur dan bangun';

  @override
  String get connectedSleepInfo =>
      'Diperkirakan ponsel semalaman. Kamu bisa mengedit atau menghapus malam mana pun.';

  @override
  String get connectedNoSensor => 'Ponsel ini tidak punya sensor langkah.';

  @override
  String get connectedNoPlay =>
      'Deteksi jalan dan tidur memerlukan layanan Google Play di ponsel ini.';

  @override
  String get connectedPermission =>
      'Izinkan \"Aktivitas fisik\" agar ponsel bisa menghitung langkah dan gerakan.';

  @override
  String get connectedAllow => 'Izinkan';

  @override
  String get connectedHealthConnect => 'Health Connect';

  @override
  String get connectedHcInfo =>
      'Penyimpanan kesehatan Android ada di ponsel ini. Baca langkah, latihan, tidur, berat, tinggi, dan air yang disimpan aplikasi lain di sana, tanpa akun.';

  @override
  String get connectedHcAbsent =>
      'Health Connect tidak ada di ponsel ini. Tidak masalah: sensor ponsel sendiri mencakup langkah, jalan, dan tidur.';

  @override
  String get connectedHcConnect => 'Pilih yang akan dibaca';

  @override
  String get connectedSyncNow => 'Sinkronkan sekarang';

  @override
  String connectedLastSync(String time) {
    return 'Terakhir disinkronkan $time';
  }

  @override
  String get connectedNeverSynced => 'Belum disinkronkan';

  @override
  String connectedSynced(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item diperbarui',
      one: '1 item diperbarui',
      zero: 'Sudah terbaru',
    );
    return '$_temp0';
  }

  @override
  String get connectedRemove => 'Hapus data impor';

  @override
  String get connectedRemoveConfirm =>
      'Hapus semua yang diimpor dari sumber ini? Catatanmu sendiri tetap ada.';

  @override
  String connectedRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item dihapus',
      one: '1 item dihapus',
    );
    return '$_temp0';
  }

  @override
  String get connectedPrivacy =>
      'Hanya baca dan di perangkat ini. Langkah dari beberapa sumber tidak pernah dijumlah dua kali: total harian terbesar yang dipakai.';

  @override
  String get sourcePhone => 'Sensor ponsel';

  @override
  String get backupTitle => 'Cadangan & ekspor';

  @override
  String get backupSubtitle =>
      'Pindah ke ponsel baru, simpan salinan aman, atau buka datamu di tempat lain';

  @override
  String get backupIntro =>
      'Tidak ada akun dan cloud, jadi datamu hanya ada di ponsel ini. Buat file cadangan dan simpan di tempat aman, atau kirim ke ponsel lainmu.';

  @override
  String get backupEncrypted => 'Cadangan terenkripsi';

  @override
  String get backupEncryptedInfo =>
      'Semua isi aplikasi, dikunci dengan frasa sandi pilihanmu. Pulihkan di ponsel mana pun yang memakai Personality.';

  @override
  String get backupIncludePhotos => 'Sertakan foto kemajuan';

  @override
  String get backupIncludePhotosInfo => 'Membuat file lebih besar.';

  @override
  String get backupSaveFile => 'Simpan ke file';

  @override
  String get backupShare => 'Kirim';

  @override
  String get backupNever => 'Belum ada cadangan di ponsel ini';

  @override
  String backupLast(String time) {
    return 'Cadangan terakhir $time';
  }

  @override
  String get backupSaved => 'Tersimpan';

  @override
  String get backupFailed => 'Tidak berhasil. Silakan coba lagi.';

  @override
  String get backupRestoreTitle => 'Pulihkan cadangan';

  @override
  String get backupRestoreInfo =>
      'Buka file .personality dari ponsel lain, drive, atau chat.';

  @override
  String get backupChooseFile => 'Pilih file cadangan';

  @override
  String get backupExportTitle => 'Ekspor untuk aplikasi lain';

  @override
  String get backupExportInfo =>
      'Salinan yang bisa dibaca di spreadsheet atau aplikasi lain. Tidak terenkripsi dan tanpa foto.';

  @override
  String get backupCsv => 'Spreadsheet (CSV)';

  @override
  String get backupCsvInfo => 'Zip berisi satu tabel per jenis catatan';

  @override
  String get backupJson => 'JSON';

  @override
  String get backupJsonInfo => 'Semua dalam satu file, untuk pengembang';

  @override
  String get backupPrivacy =>
      'File hanya pergi ke tempat yang kamu kirim. Tanpa frasa sandi, cadangan tidak bisa dibaca siapa pun, termasuk kami, dan frasa sandi yang hilang tidak bisa dipulihkan.';

  @override
  String get backupPassphrase => 'Frasa sandi';

  @override
  String get backupPassphraseAgain => 'Ulangi frasa sandi';

  @override
  String get backupPassphraseCreate => 'Pilih frasa sandi';

  @override
  String get backupPassphraseEnter => 'Masukkan frasa sandi cadangan';

  @override
  String get backupPassphraseWarning =>
      'Kamu memerlukannya untuk memulihkan. Catat: tidak bisa diatur ulang.';

  @override
  String get backupPassphraseShort => 'Gunakan minimal 8 karakter';

  @override
  String get backupPassphraseMismatch => 'Frasa sandi tidak cocok';

  @override
  String get backupShowPassphrase => 'Tampilkan frasa sandi';

  @override
  String get backupContinue => 'Lanjut';

  @override
  String backupFound(String date, int records, int photos) {
    return 'Cadangan dari $date: $records catatan, $photos foto.';
  }

  @override
  String get backupMergeInfo =>
      'Tambah: mempertahankan isi ponsel ini dan menambahkan yang belum ada.';

  @override
  String get backupReplaceInfo =>
      'Ganti: data ponsel ini ditukar dengan cadangan.';

  @override
  String get backupMerge => 'Tambah';

  @override
  String get backupReplace => 'Ganti';

  @override
  String backupRestored(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count catatan dipulihkan',
      one: '1 catatan dipulihkan',
    );
    return '$_temp0';
  }

  @override
  String get backupErrorNotBackup => 'Itu bukan file cadangan Personality.';

  @override
  String get backupErrorDamaged => 'File cadangan rusak atau tidak lengkap.';

  @override
  String get backupErrorPassphrase => 'Frasa sandi salah.';

  @override
  String get backupErrorTooNew =>
      'Cadangan ini dari versi yang lebih baru. Perbarui aplikasi, lalu coba lagi.';

  @override
  String get exMartialArts => 'Bela diri';

  @override
  String get exFace => 'Wajah & rahang';

  @override
  String get actionDone => 'Selesai';

  @override
  String get levelBeginner => 'Pemula';

  @override
  String get levelIntermediate => 'Menengah';

  @override
  String get levelAdvanced => 'Mahir';

  @override
  String get exerciseSearch => 'Cari latihan, otot, atau alat';

  @override
  String get filterNoEquipment => 'Tanpa alat';

  @override
  String exerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count latihan',
      one: '1 latihan',
    );
    return '$_temp0';
  }

  @override
  String exerciseAlsoWorks(String muscles) {
    return 'Juga melatih: $muscles';
  }

  @override
  String get workoutsTitle => 'Latihan terpandu';

  @override
  String get workoutsSubtitle =>
      'Ikuti dengan pengatur waktu dan figur bergerak';

  @override
  String get workoutsMore => 'Dapatkan lebih banyak latihan';

  @override
  String workoutMinutes(int count) {
    return '$count mnt';
  }

  @override
  String workoutRounds(int count) {
    return '$count putaran';
  }

  @override
  String workoutSeconds(int count) {
    return '$count dtk';
  }

  @override
  String workoutReps(int count) {
    return '$count rep';
  }

  @override
  String get workoutEachSide => 'tiap sisi';

  @override
  String get workoutStart => 'Mulai latihan';

  @override
  String get workoutGetReady => 'Bersiap';

  @override
  String workoutRoundOf(int round, int total) {
    return 'Putaran $round dari $total';
  }

  @override
  String workoutSide(int side) {
    return 'Sisi $side dari 2';
  }

  @override
  String workoutUpNext(String name) {
    return 'Berikutnya: $name';
  }

  @override
  String get workoutPrevious => 'Sebelumnya';

  @override
  String get workoutPause => 'Jeda';

  @override
  String get workoutResume => 'Lanjutkan';

  @override
  String get workoutSkip => 'Lewati';

  @override
  String get workoutDone => 'Latihan selesai. Kerja bagus!';

  @override
  String workoutDoneMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count menit bergerak',
      one: '1 menit bergerak',
    );
    return '$_temp0';
  }

  @override
  String get contentTitle => 'Paket konten';

  @override
  String get contentSubtitle =>
      'Unduh lebih banyak latihan, ilustrasi, dan rutinitas';

  @override
  String get contentGetMore => 'Dapatkan lebih banyak latihan';

  @override
  String get contentGetMoreInfo =>
      'Lebih dari 1.500 latihan, ilustrasi, yoga, bela diri, dan rutinitas wajah & rahang. Gratis, unduh hanya yang kamu perlukan.';

  @override
  String get contentIntro =>
      'Paket gratis dan opsional. Unduh hanya yang kamu perlukan; setelah di ponsel, paket berfungsi offline dan bisa dihapus kapan saja.';

  @override
  String get contentWifiOnly => 'Unduh hanya lewat Wi-Fi';

  @override
  String get contentDownload => 'Unduh';

  @override
  String get contentUpdate => 'Perbarui';

  @override
  String get contentRemove => 'Hapus';

  @override
  String get contentOnPhone => 'Di ponsel ini';

  @override
  String get contentInstalled => 'Paket siap dipakai';

  @override
  String contentRemoveConfirm(String name) {
    return 'Hapus \"$name\" dari ponsel ini? Kamu bisa mengunduhnya lagi nanti.';
  }

  @override
  String get contentOffline =>
      'Kamu sedang offline. Sambungkan ke internet untuk melihat paket.';

  @override
  String get contentWifiNeeded =>
      'Sambungkan ke Wi-Fi, atau matikan \"Hanya lewat Wi-Fi\".';

  @override
  String get contentDamaged =>
      'Unduhan tidak lolos pemeriksaan, jadi tidak dipakai. Silakan coba lagi.';

  @override
  String get contentFailed =>
      'Tidak bisa mengunduh sekarang. Silakan coba lagi.';

  @override
  String get contentRetry => 'Coba lagi';

  @override
  String get contentPrivacy =>
      'Paket hanya berasal dari github.com/prashantkeshr/personality-content dan diperiksa sebelum dipakai. Mengunduh tidak pernah mengirim apa pun tentangmu, dan data kesehatanmu tidak pernah memakai internet.';

  @override
  String get navGrowth => 'Pertumbuhanku';

  @override
  String get growthSearchHint => 'Cari latihan, teknik, dan tips';

  @override
  String get growthProgress => 'Kemajuanmu';

  @override
  String get growthCoachSoon => 'Segera hadir: pelatih pribadi di perangkat.';

  @override
  String get profileMenu => 'Kamu';

  @override
  String get blueprintTitle => 'Cetak birumu';

  @override
  String get blueprintIntro =>
      'Setiap area berdiri sendiri, tanpa satu skor. Hanya yang berjalan baik dan langkah kecil berikutnya.';

  @override
  String get blueprintNextStep => 'Langkah berikutnya';

  @override
  String get blueprintGo => 'Ayo';

  @override
  String get blueprintFocus => 'Fokusmu';

  @override
  String get blueprintExplore => 'Area lain';

  @override
  String get blueprintPickGoals =>
      'Pilih tujuanmu untuk membentuk cetak birumu';

  @override
  String get blueprintNoData => 'Belum ada catatan';

  @override
  String blueprintDaysMet(int count) {
    return '$count dari 7 hari';
  }

  @override
  String blueprintPercent(int percent) {
    return '$percent% dua minggu ini';
  }

  @override
  String get areaBody => 'Tubuh & berat';

  @override
  String get areaFitness => 'Kebugaran';

  @override
  String get areaPosture => 'Postur';

  @override
  String get areaSleep => 'Tidur';

  @override
  String get areaHydration => 'Hidrasi';

  @override
  String get areaHabits => 'Kebiasaan';

  @override
  String get areaStyle => 'Gaya';

  @override
  String get areaGrooming => 'Perawatan diri';

  @override
  String get areaSkills => 'Keterampilan & bela diri';

  @override
  String get actSetBodyPlan => 'Atur rencana tubuhmu';

  @override
  String get actLogWeight => 'Catat berat badanmu';

  @override
  String get actStartWorkout => 'Mulai latihan terpandu';

  @override
  String get actCheckPosture => 'Cek posturmu';

  @override
  String get actLogSleep => 'Catat tidur semalam';

  @override
  String get actAddWater => 'Minum segelas air';

  @override
  String get actDoHabits => 'Centang kebiasaan hari ini';

  @override
  String get actAddClothes => 'Tambahkan pakaian ke lemarimu';

  @override
  String get actBuildOutfit => 'Susun padu padan';

  @override
  String get actTakeSnapshot => 'Ambil foto minggu ini';

  @override
  String get actPractiseSkill => 'Latih bela diri';

  @override
  String get whyTitle => 'Mengapa saya melihat ini?';

  @override
  String get whyBenefit => 'Manfaatnya';

  @override
  String get whyAlternatives => 'Cara lain';

  @override
  String get whyYourGoal =>
      'Kamu memilih ini sebagai salah satu tujuan, dan belum ada catatan. Satu langkah kecil sudah cukup.';

  @override
  String get whyNoRecords =>
      'Belum ada catatan di sini, jadi ini tempat yang mudah untuk mulai jika kamu tertarik.';

  @override
  String get whyOnTrack =>
      'Kamu sesuai jalur minggu ini. Pertahankan ritmenya.';

  @override
  String get whyPartly => 'Minggu ini kamu sudah setengah jalan.';

  @override
  String get whyBehind =>
      'Area ini kurang diperhatikan belakangan. Satu langkah kecil mengembalikannya.';

  @override
  String get benefitBody =>
      'Menimbang rutin menunjukkan tren sebenarnya, jadi naik-turun harian tidak lagi mengkhawatirkan.';

  @override
  String get benefitFitness =>
      'Bergerak hampir setiap hari meningkatkan energi, suasana hati, dan tidur.';

  @override
  String get benefitPosture =>
      'Cek sesekali mencegah ketegangan leher dan punggung menumpuk.';

  @override
  String get benefitSleep =>
      'Tidur teratur membantu fokus, nafsu makan, dan pemulihan.';

  @override
  String get benefitHydration =>
      'Cukup minum membantu energi, kulit, dan konsentrasi.';

  @override
  String get benefitHabits =>
      'Kebiasaan kecil harian menghasilkan perubahan terbesar.';

  @override
  String get benefitStyle =>
      'Tahu isi lemarimu membuat bersiap lebih cepat dan percaya diri.';

  @override
  String get benefitGrooming =>
      'Foto mingguan menunjukkan bagaimana rutinitas mengubah banyak hal seiring waktu.';

  @override
  String get benefitSkills =>
      'Bela diri membangun kebugaran, keseimbangan, fokus, dan kepercayaan diri sekaligus.';

  @override
  String get altBody =>
      'Pantau ukuran tubuh alih-alih berat, atau ikuti rencana diet & tubuhmu.';

  @override
  String get altFitness =>
      'Jalan cepat, rutinitas yoga, atau latihan bela diri semuanya dihitung.';

  @override
  String get altPosture =>
      'Lakukan latihan Penyegaran meja, atau atur pengingat postur.';

  @override
  String get altSleep =>
      'Coba latihan Bersantai, atau atur pengingat waktu tidur.';

  @override
  String get altHydration =>
      'Atur pengingat minum, atau taruh botol dalam jangkauan.';

  @override
  String get altHabits =>
      'Mulai dengan satu kebiasaan kecil, atau pakai rutinitas siap pakai.';

  @override
  String get altStyle =>
      'Temukan warnamu, atau jelajahi gaya yang cocok untukmu.';

  @override
  String get altGrooming => 'Cek bentuk wajahmu untuk ide gaya rambut.';

  @override
  String get altSkills =>
      'Mulai dengan ayunan kaki Kalaripayattu, dand-baithak Kushti, atau dasar tinju.';

  @override
  String get skillsTitle => 'Keterampilan & bela diri';

  @override
  String get skillsIntro =>
      'Bela diri India dan dunia, masing-masing dengan teknik, latihan, dan tipsnya.';

  @override
  String get skillsIndian => 'Bela diri India';

  @override
  String get skillsWorld => 'Bela diri dunia';

  @override
  String get skillsSeeAll => 'Lihat semua';

  @override
  String skillsTechniques(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count teknik',
      one: '1 teknik',
    );
    return '$_temp0';
  }

  @override
  String get skillsTechniquesTitle => 'Teknik & latihan';

  @override
  String get skillsGetPackShort => 'Tips · teknik untuk diunduh';

  @override
  String get skillsGetPack => 'Unduh tekniknya';

  @override
  String get skillsGetPackInfo => 'Gratis dan kecil. Membuka Paket konten.';

  @override
  String get skillsTrains => 'Melatih';

  @override
  String get skillsTips => 'Tips & trik';

  @override
  String get skillsWorkouts => 'Latihan terpandu';

  @override
  String get skillsSafety =>
      'Hanya latihan mandiri: kuda-kuda, gerak kaki, latihan bayangan, dan pengondisian. Pelajari sparring, latihan berpasangan, dan senjata dari guru yang berkualifikasi.';

  @override
  String get kindStance => 'Kuda-kuda';

  @override
  String get kindTechnique => 'Teknik';

  @override
  String get kindDrill => 'Latihan';

  @override
  String get kindConditioning => 'Pengondisian';

  @override
  String get searchEmpty =>
      'Cari semua latihan, teknik bela diri, tips, dan program latihan.';

  @override
  String searchNoResults(String query) {
    return 'Tidak ditemukan apa pun untuk \"$query\".';
  }

  @override
  String get searchSkills => 'Bela diri';

  @override
  String get searchExercises => 'Latihan & teknik';

  @override
  String get searchWorkouts => 'Program latihan';

  @override
  String get searchTips => 'Tips & trik';

  @override
  String searchMore(int count) {
    return '$count lagi: persempit pencarianmu';
  }

  @override
  String get searchClear => 'Hapus';

  @override
  String get featureStyleDna => 'DNA gaya';

  @override
  String get featureGetReady => 'Bersiap untuk…';

  @override
  String get featureOutfitCalendar => 'Kalender padu padan';

  @override
  String get featureWardrobeStats => 'Statistik lemari';

  @override
  String get featureGlasses => 'Pencari kacamata';

  @override
  String get dnaSaved => 'DNA gaya disimpan';

  @override
  String get dnaYour => 'DNA gayamu';

  @override
  String get dnaEmpty =>
      'Pilih yang terasa seperti dirimu di bawah. Semua saran di aplikasi mengikutinya.';

  @override
  String get dnaPaletteDone => 'Warnamu';

  @override
  String get dnaFindPalette => 'Temukan warnamu';

  @override
  String get dnaFindShape => 'Temukan bentuk wajah';

  @override
  String get dnaStyles => 'Gaya yang kamu suka';

  @override
  String get dnaStylesHelp => 'Pilih sebanyak yang kamu mau.';

  @override
  String get dnaFits => 'Potongan pakaian yang kamu suka';

  @override
  String get dnaFitsHelp =>
      'Dipakai untuk tips padu padan dan kekurangan lemari.';

  @override
  String get dnaOccasions => 'Acara yang paling sering';

  @override
  String get dnaOccasionsHelp =>
      'Membentuk kekurangan lemari dan kalender padu padan.';

  @override
  String get dnaCultural => 'Pakaian budaya dan tradisional';

  @override
  String get dnaCulturalHelp =>
      'Agar ide perayaan dan pernikahan sesuai tradisimu.';

  @override
  String get dnaModesty => 'Tingkat tertutup yang kamu suka';

  @override
  String get dnaModestyHelp => 'Setiap ide padu padan menghormatinya.';

  @override
  String get dnaBudget => 'Anggaran';

  @override
  String get dnaBudgetHelp =>
      'Hanya untuk kekurangan dan ide belanja. Tidak pernah dibagikan.';

  @override
  String get fitPrefSlim => 'Ramping';

  @override
  String get fitPrefRegular => 'Reguler';

  @override
  String get fitPrefRelaxed => 'Longgar';

  @override
  String get fitPrefOversized => 'Oversized';

  @override
  String get fitPrefTailored => 'Dijahit pas';

  @override
  String get culturalIndianEthnic => 'Etnik India';

  @override
  String get culturalModest => 'Busana modest';

  @override
  String get culturalWestern => 'Barat';

  @override
  String get culturalFusion => 'Perpaduan Indo-Barat';

  @override
  String get modestyRelaxed => 'Santai';

  @override
  String get modestyModerate => 'Sedang';

  @override
  String get modestyCovered => 'Tertutup penuh';

  @override
  String get budgetValue => 'Hemat';

  @override
  String get budgetMidRange => 'Menengah';

  @override
  String get budgetPremium => 'Premium';

  @override
  String get readyIntro =>
      'Pilih untuk apa kamu bersiap. Kamu akan mendapat satu daftar: pakaian, perawatan, dan cara membawa diri.';

  @override
  String readyProgress(int done, int total) {
    return '$done dari $total siap';
  }

  @override
  String get readyOpen => 'Buka';

  @override
  String get readyEvInterview => 'Wawancara';

  @override
  String get readyEvPresentation => 'Presentasi';

  @override
  String get readyEvOffice => 'Hari kantor';

  @override
  String get readyEvDate => 'Kencan';

  @override
  String get readyEvWedding => 'Pernikahan';

  @override
  String get readyEvFestival => 'Perayaan';

  @override
  String get readyEvParty => 'Pesta';

  @override
  String get readyEvCasual => 'Jalan-jalan';

  @override
  String get readyEvGym => 'Gym';

  @override
  String get readyEvTravel => 'Perjalanan';

  @override
  String get readySecOutfit => 'Pakaian';

  @override
  String get readySecGrooming => 'Perawatan';

  @override
  String get readySecPresentation => 'Postur, napas, dan suara';

  @override
  String get readySecFinalChecks => 'Sebelum berangkat';

  @override
  String get readyPlanned => 'Pakai padu padan yang kamu rencanakan hari ini';

  @override
  String get readySuggested => 'Pakai ini dari lemarimu';

  @override
  String get readyGuideInterview =>
      'Rapi dan polos: kemeja atau blus yang disetrika, celana atau rok bahan, sepatu tertutup';

  @override
  String get readyGuidePresentation =>
      'Lapisan rapi yang nyaman untuk bergerak, dalam satu atau dua warna tenang';

  @override
  String get readyGuideOffice =>
      'Smart casual: kerah atau atasan rapi, celana yang pas, sepatu bersih';

  @override
  String get readyGuideDate =>
      'Sesuatu yang membuatmu percaya diri, sedikit lebih rapi dari biasanya';

  @override
  String get readyGuideWedding =>
      'Meriah dan necis: warna kaya atau pakaian tradisional, sepatu mengilap';

  @override
  String get readyGuideFestival =>
      'Cerah atau tradisional, nyaman untuk seharian';

  @override
  String get readyGuideParty => 'Satu item mencolok dengan dasar sederhana';

  @override
  String get readyGuideCasual => 'Nyaman dan rapi sesuai cuaca';

  @override
  String get readyGuideGym =>
      'Pakaian olahraga yang menyerap keringat dan sepatu yang menopang';

  @override
  String get readyGuideTravel => 'Lapisan nyaman dan sepatu praktis';

  @override
  String get readyGuideEthnic =>
      'Pakaian tradisional: kurta, sari, sherwani, atau lehenga dalam warna meriah';

  @override
  String get readyModest =>
      'Pilih pakaian yang menutup penuh, sesuai keinginanmu';

  @override
  String get readyFitSlim => 'Pilih potongan ramping dan bersih';

  @override
  String get readyFitRegular => 'Pilih potongan reguler yang nyaman';

  @override
  String get readyFitRelaxed => 'Tetap longgar, tapi rapi di bahu';

  @override
  String get readyFitOversized =>
      'Imbangi pakaian oversized dengan satu yang pas';

  @override
  String get readyFitTailored => 'Pakaian jahitan: cek lengan dan kelim';

  @override
  String get readyColours => 'Pakai warna terbaikmu di dekat wajah';

  @override
  String get readyPress => 'Setrika atau uap pakaianmu';

  @override
  String get readyShoes => 'Bersihkan atau semir sepatumu';

  @override
  String get readyLayer => 'Bawa lapisan sesuai cuaca';

  @override
  String readyHairStyle(String style) {
    return 'Rambut: $style cocok dengan bentuk wajahmu';
  }

  @override
  String get readyHairTidy => 'Tata atau rapikan rambut';

  @override
  String readyBeardStyle(String style) {
    return 'Jenggot: bentuk menjadi $style';
  }

  @override
  String get readyBeardTidy => 'Rapikan atau cukur; bersihkan garis leher';

  @override
  String get readySkin => 'Bersihkan dan lembapkan';

  @override
  String get readySunscreen => 'Tabir surya untuk di luar ruangan';

  @override
  String get readyNails => 'Kuku bersih dan dipotong';

  @override
  String get readyScentLight => 'Wewangian ringan, atau tanpa';

  @override
  String get readyGymHair => 'Ikat rambut; bawa handuk';

  @override
  String get readyPosture =>
      'Berdiri tegak: bahu ke belakang dan turun, dagu sejajar';

  @override
  String get readyBreath => 'Bernapas pelan selama semenit: tarik 4, buang 6';

  @override
  String get readyFaceWarmup => 'Pemanasan wajah dan suara selama dua menit';

  @override
  String get readyVoice =>
      'Bicara sedikit lebih lambat dari biasanya, dan beri jeda';

  @override
  String get readyEyeContact => 'Kontak mata ramah, lalu alihkan sebentar';

  @override
  String get readyThreePoints => 'Hafalkan tiga poin utamamu';

  @override
  String get readyDocuments => 'Salinan dokumen atau slide, dan pulpen';

  @override
  String get readyTravelDocs => 'Identitas, tiket, pengisi daya, dan obat';

  @override
  String get readyGymKit => 'Air, handuk, sepatu, dan baju ganti';

  @override
  String get readyGift => 'Hadiah atau shagun';

  @override
  String get readyWater => 'Sebotol air';

  @override
  String get readyPhone => 'Ponsel terisi, kunci, dan dompet';

  @override
  String get readyEarly => 'Berangkat lebih awal agar tiba dengan tenang';

  @override
  String get calendarEarlier => 'Sebelumnya';

  @override
  String get calendarLater => 'Sesudahnya';

  @override
  String get calendarNoOutfits =>
      'Simpan beberapa padu padan dulu, lalu rencanakan di sini.';

  @override
  String get calendarToday => 'Hari ini';

  @override
  String get calendarPlan => 'Rencanakan';

  @override
  String get calendarWorn => 'Dipakai';

  @override
  String get calendarWoreIt => 'Sudah dipakai';

  @override
  String get calendarRemove => 'Hapus';

  @override
  String get calendarPickTitle => 'Pilih padu padan';

  @override
  String get calendarNoneForOccasion =>
      'Belum ada padu padan tersimpan untuk acara ini.';

  @override
  String statsPriceTitle(String name) {
    return 'Berapa harga $name?';
  }

  @override
  String get statsPrice => 'Harga';

  @override
  String get statsPriceHelp =>
      'Opsional. Tetap di ponsel ini; kosongkan untuk menghapus.';

  @override
  String statsWears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dipakai $count kali',
      one: 'dipakai sekali',
      zero: 'belum dipakai',
    );
    return '$_temp0';
  }

  @override
  String statsLastWorn(String date) {
    return 'terakhir $date';
  }

  @override
  String get statsAddPrice => 'Tambah harga';

  @override
  String get statsEmpty =>
      'Tambahkan pakaian ke lemari dan tandai padu padan yang dipakai untuk melihat apa yang benar-benar kamu pakai.';

  @override
  String get statsItems => 'item';

  @override
  String get statsTotalWears => 'kali dipakai';

  @override
  String get statsNeutrals => 'dasar netral';

  @override
  String get statsGaps => 'Yang kurang';

  @override
  String get statsMostWorn => 'Paling sering dipakai';

  @override
  String get statsBestValue => 'Paling bernilai';

  @override
  String get statsBestValueHelp => 'Biaya per pakai terendah sejauh ini.';

  @override
  String statsPerWear(String price) {
    return '$price per pakai';
  }

  @override
  String get statsNeverWorn => 'Belum dipakai';

  @override
  String get statsNeverWornHelp =>
      'Coba salah satunya minggu ini, atau berikan ke orang lain.';

  @override
  String get gapBottoms => 'Bawahan';

  @override
  String get gapAdviceBottoms =>
      'Tambahkan celana, jeans, atau rok agar atasan bisa jadi padu padan.';

  @override
  String get gapFootwear => 'Sepatu';

  @override
  String get gapAdviceFootwear =>
      'Satu pasang serbaguna (sneaker putih atau loafer polos) melengkapi sebagian besar padu padan.';

  @override
  String get gapWorkTop => 'Atasan kerja';

  @override
  String get gapAdviceWorkTop =>
      'Kemeja atau blus polos putih, biru muda, atau netral lembut.';

  @override
  String get gapFormalWear => 'Sesuatu yang formal';

  @override
  String get gapAdviceFormalWear =>
      'Blazer, jas, atau gaun formal untuk hari penting.';

  @override
  String get gapFestiveEthnic => 'Pakaian perayaan atau tradisional';

  @override
  String get gapAdviceFestiveEthnic =>
      'Satu kurta, sari, atau setelan etnik dalam warna dari paletmu.';

  @override
  String get gapNeutralBasics => 'Dasar netral';

  @override
  String get gapAdviceNeutralBasics =>
      'Tambahkan dua pakaian netral (biru tua, krem, abu-abu, putih) agar yang berwarna mudah dipadukan.';

  @override
  String get gapSportwear => 'Pakaian olahraga';

  @override
  String get gapAdviceSportwear =>
      'Atasan yang menyerap keringat dan celana pendek atau legging untuk berolahraga.';

  @override
  String get gapOuterwear => 'Jaket atau lapisan';

  @override
  String get gapAdviceOuterwear =>
      'Jaket atau kardigan untuk hari yang lebih sejuk.';

  @override
  String get glassesSizeTip =>
      'Ukuran sama pentingnya dengan bentuk: bingkai sebaiknya selebar wajahmu di pelipis, dengan mata dekat bagian tengah setiap lensa.';

  @override
  String get glassesTryOn => 'Coba langsung';

  @override
  String get glassesNoShape =>
      'Analisis bentuk wajahmu untuk rekomendasi pribadi';

  @override
  String glassesForShape(String shape) {
    return 'Diurutkan untuk wajah $shape-mu';
  }

  @override
  String get glassesHonest =>
      'Panduan dari aturan kontras, bukan penilaian penampilan. Pakai yang kamu suka.';

  @override
  String get fitGreat => 'Sangat cocok';

  @override
  String get fitGood => 'Cocok';

  @override
  String get fitLess => 'Kurang menyeimbangkan';

  @override
  String get fitReasonAddsAngles =>
      'Garis bersudut memberi ketegasan pada fitur yang lebih lembut dan bulat.';

  @override
  String get fitReasonSoftensAngles =>
      'Bingkai melengkung melembutkan rahang dan dahi yang tegas.';

  @override
  String get fitReasonAddsLength =>
      'Bingkai yang lebih tinggi memecah panjang dan menambah lebar.';

  @override
  String get fitReasonBalancesForehead =>
      'Bingkai ringan atau berat di bawah menyeimbangkan dahi yang lebar.';

  @override
  String get fitReasonLiftsCheekbones =>
      'Bingkai oval atau naik di ujung menonjolkan tulang pipi.';

  @override
  String get fitReasonSuitsMost =>
      'Proporsi seimbang cocok dengan sebagian besar bingkai; pilih yang kamu suka.';

  @override
  String get fitReasonEchoesShape =>
      'Bentuk ini mengulang garis wajahmu, jadi kurang menyeimbangkan. Tetap pilihanmu.';

  @override
  String get fitReasonUnknownShape =>
      'Analisis wajahmu untuk melihat bagaimana bingkai ini menyeimbangkan bentukmu.';

  @override
  String get whyFeedBodyPlan => 'Kamu belum mengatur rencana diet dan tubuh.';

  @override
  String get benefitFeedBodyPlan =>
      'Rencana mengubah tujuanmu menjadi kalori, menu, dan latihan harian yang sesuai daerahmu.';

  @override
  String get whyFeedGoals =>
      'Tujuanmu menentukan misi, tips, dan area yang kamu lihat lebih dulu.';

  @override
  String get benefitFeedGoals =>
      'Memilih fokus membuat aplikasi tetap tentang hal yang penting bagimu.';

  @override
  String get whyFeedSnapshot => 'Belum ada foto kemajuan minggu ini.';

  @override
  String get benefitFeedSnapshot =>
      'Foto mingguan menunjukkan perubahan nyata yang terlewat oleh cermin.';

  @override
  String get whyFeedFace => 'Bentuk wajahmu belum dianalisis.';

  @override
  String get benefitFeedFace =>
      'Ini menyesuaikan ide rambut, jenggot, dan kacamata untukmu.';

  @override
  String get whyFeedHairstyles => 'Ini mengikuti bentuk wajahmu.';

  @override
  String get benefitFeedHairstyles =>
      'Gaya yang menyeimbangkan fiturmu, dengan alasan untuk masing-masing.';

  @override
  String get whyFeedTryOn =>
      'Kamu bisa melihat kacamata dan jenggot secara langsung sebelum mengubah apa pun.';

  @override
  String get benefitFeedTryOn =>
      'Lihat di wajahmu sendiri, secara pribadi, di ponsel ini.';

  @override
  String get whyFeedColours => 'Palet warnamu belum diatur.';

  @override
  String get benefitFeedColours =>
      'Tahu warnamu membuat padu padan dan belanja lebih mudah.';

  @override
  String get whyFeedOutfit => 'Pakaianmu sudah cukup untuk ide padu padan.';

  @override
  String get benefitFeedOutfit =>
      'Ide dari yang sudah kamu miliki, beserta alasannya.';

  @override
  String get whyFeedPosture =>
      'Cek postur cepat berguna setiap satu atau dua minggu.';

  @override
  String get benefitFeedPosture =>
      'Kenali ketegangan leher dan punggung lebih awal, dengan latihan yang membantu.';

  @override
  String get whyFeedExercise =>
      'Bergerak hampir setiap hari membantu semua tujuan lainnya.';

  @override
  String get benefitFeedExercise =>
      'Latihan terpandu dan lebih dari 1.500 latihan, banyak yang tanpa alat.';

  @override
  String get onboardingGoalsTitle => 'Apa yang ingin kamu tingkatkan?';

  @override
  String get onboardingGoalsBody =>
      'Pilih yang penting bagimu. Kami hanya menanyakan yang dibutuhkan tujuan ini, dan kamu bisa mengubahnya kapan saja.';

  @override
  String get onboardingAboutFocused =>
      'Hanya yang dibutuhkan tujuanmu. Sisanya bisa ditambahkan nanti di Profil.';

  @override
  String get settingsTimeFormat => 'Format waktu';

  @override
  String get timeFormatDevice => 'Sama dengan perangkat';

  @override
  String get timeFormat12 => '12 jam';

  @override
  String get timeFormat24 => '24 jam';

  @override
  String get settingsSecurity => 'Keamanan';

  @override
  String get actionOk => 'OK';

  @override
  String get lockTitle => 'Kunci aplikasi';

  @override
  String get lockSubtitle => 'Minta PIN atau sidik jari saat aplikasi dibuka';

  @override
  String get lockEnterPin => 'Masukkan PIN-mu';

  @override
  String get lockSetPin => 'Pilih PIN';

  @override
  String get lockConfirmPin => 'Masukkan PIN lagi';

  @override
  String get lockPinRules =>
      '4 sampai 8 digit. Jika lupa, aplikasi tidak bisa dibuka tanpa menghapus datanya, jadi pilih yang mudah diingat.';

  @override
  String get lockPinMismatch => 'PIN tidak cocok. Coba lagi.';

  @override
  String get lockWrongPin => 'PIN salah';

  @override
  String lockWait(int seconds) {
    return 'Terlalu banyak percobaan. Tunggu $seconds dtk.';
  }

  @override
  String get lockUseFingerprint => 'Buka dengan sidik jari';

  @override
  String get lockBiometricReason => 'Buka Personality';

  @override
  String get lockForgot => 'Lupa PIN?';

  @override
  String get lockForgotInfo =>
      'Demi privasimu, PIN tidak bisa diatur ulang atau dipulihkan, bahkan oleh kami. Jika buka dengan sidik jari aktif, gunakan itu lalu ubah PIN di Setelan. Jika tidak, menghapus data aplikasi (Setelan Android → Aplikasi) menghilangkan kunci dan semua isi aplikasi; pulihkan dari cadangan setelahnya.';

  @override
  String get lockOn => 'Kunci aplikasi aktif';

  @override
  String get lockOff => 'Kunci aplikasi mati';

  @override
  String get lockChangePin => 'Ubah PIN';

  @override
  String get lockChanged => 'PIN diubah';

  @override
  String get lockDelete => 'Hapus';

  @override
  String lockDigits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count digit dimasukkan',
      one: '1 digit dimasukkan',
      zero: 'Belum ada digit',
    );
    return '$_temp0';
  }

  @override
  String get widgetNext => 'Berikutnya';

  @override
  String get widgetAddGlass => '+ Gelas';

  @override
  String get widgetLocked => 'Buka aplikasi untuk melihat tugas berikutnya';

  @override
  String get widgetNothingNext => 'Tidak ada rencana saat ini';
}
