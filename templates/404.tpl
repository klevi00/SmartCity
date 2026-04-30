<?php /** @var string $base_path @var string|null $error */ ?>
<?php $this->layout('layout', ['title' => 'Pagina non trovata']) ?>

<?php $this->start('body') ?>

<section class="section" style="min-height:calc(100vh - 250px);display:flex;align-items:center">
  <div style="text-align:center;margin:0 auto">
    <div style="font-family:var(--serif);font-size:120px;font-weight:700;color:var(--brand);line-height:1;opacity:0.15">404</div>
    <div style="font-family:var(--serif);font-size:34px;font-weight:600;margin-top:-20px">Pagina non trovata</div>
    <p style="color:var(--muted);font-size:16px;margin-top:12px;max-width:400px;margin-left:auto;margin-right:auto;line-height:1.6">
      La pagina che cerchi non esiste o è stata rimossa. Torna alla home e riprova.
    </p>
    <div style="display:flex;gap:14px;justify-content:center;margin-top:32px">
      <a href="<?= $base_path ?>/" class="btn btn-primary btn-lg">Torna alla home</a>
      <a href="<?= $base_path ?>/cerca" class="btn btn-ghost btn-lg">Cerca un viaggio</a>
    </div>
  </div>
</section>

<?php $this->stop() ?>
