<template>
  <div id="menu-frame">
    <nav id="menu">
      <div style="color: #ffffff; padding: 2em 0; text-align: center">
        ロゴを入れる場所
      </div>
      <ul>
        <li
          v-for="value in menuList"
          v-bind:key="value.path"
          :class="{ 'router-active': $route.path.startsWith(value.path) }"
        >
          <router-link :to="value.path">{{ value.title }}</router-link>
        </li>
      </ul>
    </nav>
  </div>
</template>

<script>
export default {
  data() {
    return {
      menuList: [
        {
          path: "/tours",
          title: this.$i18n.t("pages.tours.title"),
        },
        {
          path: "/createaccount",
          title: this.$i18n.t("pages.createaccount.title"),
        },
      ],
    };
  },
};
</script>

<style lang="scss" scoped>
#menu-frame {
  width: 215px;
  background-color: var(--color-theme);
  box-shadow: 5px 0 20px 5px rgba(0, 0, 0, 0.15);
}

#menu {
  position: sticky;
  top: 0;
  padding: 0;
}

#menu ul {
  margin: 0;
  padding: 0;
  list-style-type: none;
  margin-top: 2em;
}

#menu li {
  padding: 0;
  margin: 0;
  display: table;
  width: 100%;
  box-sizing: border-box;
}

#menu li a {
  box-sizing: border-box;
  padding: 0.5em 1em;
  text-decoration: none;
  color: var(--color-light-gray);
  width: 100%;
  margin: 0;
  text-align: left;
  font-size: 1.05rem;
  font-weight: bold;
  height: 3em;
  display: table-cell;
  vertical-align: middle;
}

#menu li a:hover {
  color: var(--color-white);
  background-color: var(--color-dark-theme);
  opacity: 0.75;
}

.router-active {
  background-color: var(--color-dark-theme);
}
</style>
