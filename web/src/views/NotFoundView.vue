<template>
  <div>
    <h1>{{ $t("app_name") }}</h1>
    <h2>{{ $t("pages.notfound.title") }}</h2>
    <p>
      <button @click="$router.push('/')" class="link button-large button-green">
        {{ $t("pages.notfound.link") }}
      </button>
    </p>
    <p class="info">{{ $t("pages.notfound.info") }}</p>
  </div>
</template>

<style scoped>
.link {
  margin: 3em;
}

.info {
  padding: 2em;
  box-sizing: border-box;
}
</style>
