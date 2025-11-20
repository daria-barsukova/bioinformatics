## 1. Введение

**Цель работы:**
- Предсказать трехмерную структуру белка по аминокислотной последовательности с помощью двух фолдинговых инструментов (RoseTTAFold2 и AlphaFold2), затем выполнить парное выравнивание предсказанных структур (метод jCE в RCSB) и визуализировать результаты, а также проанализировать степень совпадения структур.

**Исходная последовательность (FASTA):**
- MKGMLTGPVTILNWSWPREDITHEEQTKQLALAIRDEVLDLEAAGIKIIQIDEAALREKLPLRKSDWHAKYLDWAIPAFRLVHSAVKPTTQIHTHMCYSE

## 2. Инструменты и версии

- RoseTTAFold2 -- ColabFold notebook: colab/RoseTTAFold2.ipynb

- AlphaFold2 -- ColabFold AlphaFold2 notebook: colab/AlphaFold2.ipynb

- Выравниватель пар структур: jCE (через RCSB Pairwise Structure Alignment, Alignment Method = jCE)

- Визуализация: RCSB Mol* (экспорт: .glb, .png, .mp4)

## 3. Reproducible steps

- Создала sequence.fasta с указанной последовательностью
- Запустила RoseTTAFold2 в Google Colab. Сохранила .ipynb и все выводные файлы (PDB, лог). Примечание: в Colab обязательно выбрать Runtime -> Change runtime type -> Hardware accelerator: GPU
- Запустила AlphaFold2 через ColabFold. Сохранила .ipynb и выводы
- Взяла основные PDB файлы из папки pairwise (roseTTAFold2/pairwise/.pdb, alphaFold2/pairwise/.pdb)
- Загрузила обе структуры в RCSB Pairwise Structure Alignment, выбрала jCE, получила выравнивание и экспортировала результаты
- Экспортировала визуализацию в Mol* (molstar-model.glb, molstar-image.png, rcsb_render.mp4) и сохранила скриншоты интерфейса
- Собрала логи в pairwise/result

## 4. Интерпретация метрик

- RMSD = 0.48 -- очень низкое отклонение: структуры практически совпадают на атомном уровне. (<2 -- хорошее совпадение)
- TM-score = 0.98 -- почти идеальная топологическая совпадаемость (TM-score ∈ (0,1], >0.5 указывает на общую правильную топологию; >0.9 -- очень сильное совпадение)
- Identity = 100% -- последовательности полностью идентичны (ожидалось, т.к. это две предсказанные структуры одной и той же последовательности)

**Вывод:**
 Предсказания AlphaFold2 и RoseTTAFold2 дали практически идентичную структуру для данной последовательности; выравнивание jCE это подтверждает.

![rcsb_image.png](pairwise\result\rcsb_image.png)
